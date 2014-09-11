describe("chat socket", function() {
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
		setFixtures(fixt);
 
    		Chat.setup();
	};
	
	describe("Initialization", function() {
		it("initializes websocket", function() {
			expect(Chat.ws).not.toBeNull();
		});
	});

	describe("Send Message", function() {
		beforeEach(function() {
			var sendSpy = jasmine.createSpy();
			spyOn(window, 'WebSocket').and.returnValue({ send: sendSpy });
			$('#input-text').val('Hello World');
			$('#send-chat-message').trigger('click');
		});

		it('triggers sendMessages handler when Send clicked', function() {
			expect(sendSpy).toHaveBeenCalled();
		});

		it('sends the correct message', function() {
			var hello = JSON.stringify({ text : "Hello World" });
			expect(sendSpy).toHaveBeenCalledWith(hello);
		});
	});
});
