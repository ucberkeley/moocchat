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
    @groups = Hash.new( [ ] )
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
    unless groups[channel][my_position]
      ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })
      ws.on(:open)    { |event| ; }
      ws.on(:message) { |event| redistribute_message(event, channel, my_position) }
      ws.on(:close)   { groups[channel][my_position] = nil }
      groups[channel][my_position] = ws
      ws.rack_response   # async Rack response
    else
      GENERIC_ASYNC_RACK_RESPONSE
    end
  end

  def redistribute_message(websocket_event, channel, my_position)
    message = extract_text(websocket_event)
    speaker = "Learner #{1+my_position}"
    json = create_text_message "#{speaker}: #{message}"
    groups[channel].each_with_index do |websocket, position|
      next if position == my_position
      websocket.send json
    end
  end

  private

  def extract_text(event)
    JSON.parse(event.data)['text']
  end

  def create_text_message(text)
    {:text => text}.to_json
  end

  def abort_with(message)
    raise MalformedWebsocketUrlError, message
    #  should notify via hoptoad or something as well
  end
end
