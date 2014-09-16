describe("chat socket", function() {

	var chatGroup = "1,2,3";
	var taskID = 2;
	var prodcution = "test";
	var hello = "Hello World";
	var JsonString = JSON.stringify({ text : hello, taskid: taskID, type: "message" });
	var message = {data: JsonString};

	var onmessageSpy = jasmine.createSpy('for ws.onmessage');

	beforeEach(function() {
		this.sendSpy = jasmine.createSpy('for ws.send');

		spyOn(window, 'WebSocket').and.returnValue({send: this.sendSpy, onmessage: onmessageSpy});
		spyOn(Chat, 'sendMessages').and.callThrough();

		var fixture = $('<div id="chat-box" class="container" data-chatgroup=' + chatGroup + ' data-taskid=' + taskID + 
			' data-production=' + prodcution + '> ' + 
			'<div class="form-group">' +
				'<input id="input-text" type="text" class="form-control" placeholder="Enter chat text here!" autofocus />' +
				'<button id="send-chat-message" class="btn btn-primary" type="submit">Send</button>' +
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
			expect(window.WebSocket).toHaveBeenCalled();
			expect(Chat.ws).not.toBeNull();
		});

		it("initializes group correctly", function() {
			expect(Chat.group).toEqual(chatGroup);
		});
		
		it("finds Send Message button", function() {
			expect(Chat.sendChatMessageButton).not.toBeNull();
		});
	});

	describe("Send Message", function() {
		beforeEach(function() {
			$('#input-text').val(hello);
			$('#send-chat-message').click();
		});

		it('triggers sendMessages handler when Send clicked', function() {
			expect(window.WebSocket).toHaveBeenCalled();
			expect(Chat.sendMessages).toHaveBeenCalled();
			expect(this.sendSpy).toHaveBeenCalledWith(JsonString);
		});
		
		it('sends the correct message', function() {
			expect(this.sendSpy).toHaveBeenCalledWith(JsonString);
		});
	});

	describe("Receive Message", function() {
		describe("chat message", function() {
			beforeEach(function() {
				Chat.ws.onmessage(message);
			});

			it('appends message to the chat', function() {
				expect($('#chat-system')).toContainText("Hello World");
			});
		});

		describe("vote to end early", function() {
			it("marks the user as finished", function() {
				//FILL IN
			});
		});
		
	});
});
