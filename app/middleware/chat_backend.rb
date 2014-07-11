require 'faye/websocket'
require 'json'
require 'erb'

module ChatDemo
  class ChatBackend
    KEEPALIVE_TIME = 15 # in seconds

    def initialize(app)
      @app     = app
      @group = {}
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })

        group_info = env["ORIGINAL_FULLPATH"].split('/')[-1]
        task_id = group_info.split(',')[-1]
        lastComma = group_info.rindex(',')
        channel = group_info[0..lastComma-1]
        clients = channel.split(',')
        group_number = clients.index(task_id)+1

        if @group.has_key?(channel)
          #send to the client who has joined the chat room
          @group[channel].each{|learner,group_position|
          note = "learner #{group_position} join the room "
          text = {:text => note}
          ws.send({:text => note}.to_json)
        }

          @group[channel].store(ws,group_number)
        else
          @group[channel]={ws => group_number}
        end



        #notify everyone that this learner join the room
        @group[channel].each{|learner,group_position|
            note = "learner #{group_number} join the room "
            text = {:text => note}
            learner.send({:text => note}.to_json)
        }

        # notify the learner his group number
        note = "you joined as learner #{group_number}"
        ws.send({:text => note}.to_json)




        ws.on :open do |event|
        end

        ws.on :message do |event|
          sender = event.current_target
          sender_pos = @group[channel][sender]
          received = JSON.parse(event.data)

          data = received["text"]
          @group[channel].each {|client, pos| 
            note = "student #{sender_pos} : #{data}"
            text = {:text => note} 
            client.send(text.to_json)
          }
        end

        ws.on :close do |event|
          #p [:close, ws.object_id, event.code, event.reason]
          @group[channel].delete(ws)
          ws = nil
        end

        # Return async Rack response
        ws.rack_response
      else
        @app.call(env)
      end
    end
  end
end
      