require 'spec_helper'
describe ChatServer do

  def make_url(channel_and_position)
    "ws://example.com:3333/foo/#{channel_and_position}"
  end

  before(:each) do
    @app = ChatServer.new(lambda { [200, {}, []] })
  end

  describe 'setup' do
    it 'creates websocket on first connection from client' do
      fake_ws = double('WS').as_null_object
      @app.groups.should be_empty
      @app.ensure_setup_socket_for('ORIGINAL_FULLPATH' => make_url("2,4,5,4"))
      @app.groups['2,4,5'][1].should be_a_kind_of Faye::WebSocket
    end
  end

  describe 'redistributing a message' do
    before :each do
      @app.stub(:extract_text).and_return "Message"
      @ev = double('websocket_event')
      @ws = Array.new(3) { double('websock').as_null_object }
      @group = '2,4,5'
      @app.groups = { @group => @ws, '3' => nil }
    end
    
    it 'goes to everyone else' do
      result = json_including :text => "Learner 2: Message"
      @ws[0].should_receive(:send).with(result)
      @ws[1].should_receive(:send).with(result)
      @ws[2].should_receive(:send).with(result)
      @app.redistribute_message(double('event'), '2,4,5', 1)
    end 
  end

  describe 'channel and position' do
    describe 'for well-formed URL' do
      { '1,3,5,3' => ['1,3,5', 1],
        '3,3' => ['3', 0],
      }.each_pair do |url, result|
        specify "URL including #{url}" do
          channel, position =
            @app.channel_and_position_from_url("ws://foo.com/app/#{url}")
          channel.should == result[0]
          position.should == result[1]
        end
      end
    end
    it 'for malformed URL should raise error' do
      ['', '1,3,5,2'].each do |bad_url|
        lambda { @app.channel_and_position_from_url(make_url bad_url) }.
          should raise_error(ChatServer::MalformedWebsocketUrlError)
      end
    end
  end

  describe 'JSON message' do
    before :each do
      ChatServer.send :public, :extract_text, :create_text_message
    end
    specify 'containing text' do
      @app.create_text_message('foo bar', 2).should include_json(:text => 'foo bar', :type => "message", :taskid => 2)
    end
    
    specify 'extracting text' do
      event = double('event', :data => @app.create_text_message('foo bar', 2))
      @app.extract_text(event).should == "foo bar"
    end
  end
end
