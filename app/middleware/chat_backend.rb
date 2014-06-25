require 'faye/websocket'
require 'json'
require 'erb'

module ChatDemo
  class ChatBackend
    KEEPALIVE_TIME = 15 # in seconds
    CHANNEL        = "chat-demo"

    def initialize(app)
      @app     = app
      @clients = []
      @groups = {}
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })
        #p "hello"
        path = env["ORIGINAL_FULLPATH"]
        #p 'path is' + path

        if @groups.has_key?(path)
          @groups[path] << ws
        else 
          @groups[path] = [ws]
        end

        ws.on :open do |event|
          #p [:open, ws.object_id]
          @clients << ws
        end

        ws.on :message do |event|
          #p [:message, event.data]
          @groups[path].each {|client| client.send(event.data) }
        end

        ws.on :close do |event|
          #p [:close, ws.object_id, event.code, event.reason]
          @clients.delete(ws)
          @groups[path].delete(ws)
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
