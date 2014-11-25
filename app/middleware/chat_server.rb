require 'faye/websocket'
require 'json'
require 'erb'

# The chat server maintains a nested hash to keep track of existing websockets.
# A chat group consists of sorted, comma-separa
#  { chatroom1 => { participant1 => websocket1, participant2 => websocket2, ...},
#    chatroom2 => { participant1 => websocket1, participant2 => websocket2, ...} }

class ChatServer

  class MalformedWebsocketUrlError < RuntimeError;  end
  
  KEEPALIVE_TIME = 30 # in seconds
  GREETING = "Learner %s"
  GENERIC_ASYNC_RACK_RESPONSE = [ -1, {}, [] ]
  attr_accessor :groups
  def initialize(app)
    @app     = app
    @groups = {}
  end
  
  def call(env)
    if Faye::WebSocket.websocket?(env)
      ensure_setup_socket_for(env)
    else
      @app.call(env)
    end
  end

  # URL for a websocket request will contain a list of N+1 comma-separated
  # numbers.  The first N numbers are the task IDs of the group members,
  # always in ascending order, and the last is taskID for *this* member.
  # So eg "7,13,23,13" is a group of 3 people with task IDs 7,13,23, and
  # the person responsible for *this* request is task ID 13.
  # Task IDs are never recycled.
  def channel_and_position_from_url(url)
    if url =~ /\b([0-9,]+),([0-9]+)\b/
      channel, my_id = $1, $2
      position = channel.split(/,/).index(my_id)
      abort_with "Malformed URL '#{url}': index out of range" unless position
    else
      abort_with "Malformed URL: #{url}"
    end
    return channel, position
  end

  def ensure_setup_socket_for(env)
    channel, my_position = channel_and_position_from_url(env['ORIGINAL_FULLPATH'])
    unless @groups.has_key?(channel) && @groups[channel][my_position]
      ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })
      @groups[channel] ||= []
      @groups[channel][my_position] = ws
      ws.on(:open)    { |event| ; }
      ws.on(:message) { |event| redistribute_message(event.data, channel, my_position) }
      ws.on(:close)   {
        @groups[channel][my_position] = nil
        # Send disconnect message, encode position in text field
        redistribute_message('{"text": "' + my_position.to_s + '", "taskid": "", "type": "disconnect"}', channel, my_position)
      }
      ws.rack_response   # async Rack response
    else
      GENERIC_ASYNC_RACK_RESPONSE
    end
  end

  def redistribute_message(websocket_data, channel, my_position)
    message = extract_text(websocket_data)
    type = extract_type(websocket_data)
    taskid = extract_taskid(websocket_data)
    if type != "heartbeat"   # Heartbeat too spammy
      puts "redistribution #{type}: #{message}"
    end
    if type == "message"
      speaker_position = channel.split(/,/).index(taskid.to_s)
      speaker = "Learner #{1+speaker_position}"
      json = create_text_message "#{speaker}: #{message}", taskid
    end
    if type == "end-vote"
      json = create_end_vote taskid
    end
    if type == "heartbeat"
      json = create_heartbeat taskid
    end
    if type == "disconnect"
      json = create_disconnect message, taskid
    end
    @groups[channel].each_with_index do |websocket, position|
      unless websocket.nil?  # May be nil if learner disconnected
        websocket.send json
      end
    end
  end

  private

  def extract_text(event)
    JSON.parse(event)['text']
  end

  def extract_taskid(event)
    JSON.parse(event)['taskid']
  end

  def extract_type(event)
    JSON.parse(event)['type']
  end

  def create_text_message(text, taskid)
    {:text => text, :type => "message", :taskid => taskid }.to_json
  end

  def create_end_vote(taskid)
    {:text => "", :type => "end-vote", :taskid => taskid }.to_json
  end

  def create_heartbeat(taskid)
    {:text => "", :type => "heartbeat", :taskid => taskid }.to_json
  end

  def create_disconnect(text, taskid)
    {:text => text, :type => "disconnect", :taskid => taskid }.to_json
  end

  def abort_with(message)
    puts "Aborting with #{message}"
    raise MalformedWebsocketUrlError, message
    #  should notify via hoptoad or something as well
  end
end
