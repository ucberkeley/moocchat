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
    @sendSpy = jasmine.createSpy 'for ws.send'
    spyOn(window, 'WebSocket').and.returnValue({send: @sendSpy})
    Chat.setup()
  it 'initializes websocket', ->
    expect(Chat.ws).not.toBeNull()
  it 'finds Send Message button', ->
    expect(Chat.sendChatMessageButton).not.toBeNull()
  it 'triggers sendMessages handler when Send clicked', ->
    pending()
    $('#input-text').val 'Hello World'
    $('#send-chat-message').trigger 'click'
    expect(@sendSpy).toHaveBeenCalled()
    
