describe 'Chat socket', ->
  beforeEach ->
    fixt = """
<div id="chat-box" class="container" data-chatgroup="1,2,3" data-taskid="4" data-production="test">
  <form id="chat-input-form" class="form-inline">
    <div class="form-group">
      <input id="input-text" type="text" class="form-control" placeholder="Enter chat text here!" autofocus />
    </div>
    <button id="send" class="btn btn-primary" type="submit">Send</button>
  </form>
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
  it 'initializes websocket', ->
    expect(Chat.ws).not.toBeNull()
  it 'triggers sendMessages handler when Send clicked', ->
    spyOn(Chat, 'handleSend').and.returnValue(true)
    $('#input-text').val 'Hello World'
    $('#send').trigger 'click'
    expect(Chat.handleSend).toHaveBeenCalled()
    
