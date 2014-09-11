describe("chat socket", function() {

	var hello = "Hello World";

	beforeEach(function() {
		var fixture = $('<div id="chat-box" class="container" data-chatgroup="1,2,3" data-taskid="2" data-production="test"> ' + 
			'<div class="form-group">' +
				'<input id="input-text" type="text" class="form-control" placeholder="Enter chat text here!" autofocus />' +
				'<button id="send" class="btn btn-primary" type="submit">Send</button>' +
			'</div>' +
			'<div class="page-header">' +
				'<h1>Chat TEST</h1>' +
			'</div>' +
				'<div id="chat-system">' +
			'</div>' +
			'<div id="chat-text">' +
			'</div>' +
		'</div>');
		setFixtures(fixture);
 
    		Chat.setup();
	});
	
	describe("Initialization", function() {
		it("initializes websocket", function() {
			expect(Chat.ws).not.toBeNull();
		});
		it("initializes group", function() {
			expect(Chat.group).not.toBeNull();
		});
		it("finds Send Message button", function() {
			expect(Chat.sendChatMessageButton).not.toBeNull();
		});
	});

	describe("Send Message", function() {
		beforeEach(function() {
			var sendSpy = jasmine.createSpy('for ws.send');
			spyOn(window, 'WebSocket').and.returnValue({ send: sendSpy });
			$('#input-text').val(hello);
			$('#send-chat-message').trigger('click');
		});

		it('triggers sendMessages handler when Send clicked', function() {
			expect(sendSpy).toHaveBeenCalled();
		});

		it('sends the correct message', function() {
			var JsonString = JSON.stringify({ text : hello });
			expect(sendSpy).toHaveBeenCalledWith(JsonString);
		});
	});

	describe("Receive Message", function() {
		beforeEach(function() {
			var JsonString = JSON.stringify({ text : hello }); 
			var message = {data: JsonString};
			Chat.ws.onmessage(message);
		});
		it('appends message to the chat', function() {
			expect($('#chat-system')).toContainText(hello);
		});
	});

});
