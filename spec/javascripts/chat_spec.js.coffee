describe 'Chat socket', ->
  beforeEach ->
    fixt = """
<div id="chat-box" class="container" data-chatgroup="1,2,3" data-taskid="2" data-production="test">
    <div class="form-group">
      <input id="input-text" type="text" class="form-control" placeholder="Enter chat text here!" autofocus />
      <button id="send" class="btn btn-primary" type="submit">Send</button>
    </div>
  <div class="page-header">
    <h1>Chat TEST</h1>
  </div>
  <div id="chat-system">
  </div>
  <div id="chat-text">
  </div>
</div>
"""
    setFixtures(fixt)
    Chat.setup()
  describe 'Initialization', ->
    beforeEach ->
      #nothing yet
    it 'initializes websocket', ->
      expect(Chat.ws).not.toBeNull()
    it 'initializes group', ->
      expect(Chat.group).not.toBeNull()
    it 'finds Send Message button', ->
      expect(Chat.sendChatMessageButton).not.toBeNull()

  describe 'Send Message', ->
    beforeEach ->
      @sendSpy = jasmine.createSpy 'for ws.send'
      spyOn(window, 'WebSocket').and.returnValue({send: @sendSpy})
      $('#input-text').val 'Hello World'
      $('#send-chat-message').trigger 'click'
    it 'triggers sendMessages handler when Send clicked', ->
      expect(@sendSpy).toHaveBeenCalled
    it 'sends the correct message', ->
      @hello = JSON.stringify {text : "Hello World" }
      expect(@sendSpy).toHaveBeenCalledWith @hello

  describe 'Receiving Message', ->
    beforeEach ->
      @hello = JSON.stringify {text : "Hello world" }
      @message = {data: @hello}
      Chat.ws.onmessage @message
    it 'appends message to the chat', ->
      expect($('#chat-system')).toContainText("Hello world")