describe("chat socket", function() {

	var chatGroup = "1,2,3";
	var groupList = ["1", "2", "3"];
	var taskID = 2; //current user
	var otherTaskId1 = 1; // another user
	var otherTaskId3 = 3;
	var prodcution = "test";
	var hello = "Hello World";
	var chatJSON = JSON.stringify({ text : hello, taskid: taskID, type: "message" });
	var sendEndVoteJSON = JSON.stringify({ text : "", taskid: taskID, type: "end-vote" });
	var receiveEndVoteJSON1 = JSON.stringify({ text : "", taskid: otherTaskId1, type: "end-vote" });
	var receiveEndVoteJSON3 = JSON.stringify({ text : "", taskid: otherTaskId3, type: "end-vote" });
	var chatMessage = {data: chatJSON};
	var voteMessage1 = {data: receiveEndVoteJSON1};
	var voteMessage3 = {data: receiveEndVoteJSON3};

	var onmessageSpy = jasmine.createSpy('for ws.onmessage');

	beforeEach(function() {
		this.sendSpy = jasmine.createSpy('for ws.send');

		spyOn(window, 'WebSocket').and.returnValue({send: this.sendSpy, onmessage: onmessageSpy});
		spyOn(Chat, 'sendMessages').and.callThrough();
		spyOn(Chat, 'vote').and.callThrough();

		var fixture = $('<div id="chat-box" class="container" data-chatgroup=' + chatGroup + ' data-taskid=' + taskID + 
			' data-production=' + prodcution + '> ' + 
			'<div class="form-group">' +
				'<input id="input-text" type="text" class="form-control" placeholder="Enter chat text here!" autofocus />' +
				'<button id="send-chat-message" class="btn btn-primary" type="submit">Send</button>' +
				'<button id="end-vote" class="btn btn-default">Vote to move on</button>' +
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
			expect(Chat.group).toEqual(groupList);
		});
		
		it("finds Send Message button", function() {
			expect(Chat.sendChatMessageButton).not.toBeNull();
		});
	});

	describe("chat messages", function() {
		describe("Sending chat", function() {
			beforeEach(function() {
				$('#input-text').val(hello);
				$('#send-chat-message').click();
			});

			it('triggers sendMessages handler when Send clicked', function() {
				expect(window.WebSocket).toHaveBeenCalled();
				expect(Chat.sendMessages).toHaveBeenCalled();
				expect(this.sendSpy).toHaveBeenCalledWith(chatJSON);
			});
			
			it('sends the correct message', function() {
				expect(this.sendSpy).toHaveBeenCalledWith(chatJSON);
			});
		});

		describe("receiving chat", function() {
			describe("chat message", function() {
				beforeEach(function() {
					Chat.ws.onmessage(chatMessage);
				});

				it('appends message to the chat', function() {
					expect($('#chat-system')).toContainText("Hello World");
				});

				it('does not change any vote statuses', function() {
					expect(Chat.vote).not.toHaveBeenCalledWith(taskID);
				})
			});
		});
	});

	describe("Voting to end chat", function() {
		describe("sending vote", function() {
			beforeEach(function() {
				$('#end-vote').click();
			});

			it('sends the message to the server', function() {
				expect(this.sendSpy).toHaveBeenCalledWith(sendEndVoteJSON);
			});

			it("marks the current user as finished", function() {
				expect(Chat.vote).toHaveBeenCalledWith(taskID);
			});
		});

		describe("receiving vote", function() {
			beforeEach(function() {
				Chat.ws.onmessage(voteMessage1);
			});

			it("marks the user as finished", function() {
				expect(Chat.vote).toHaveBeenCalledWith(otherTaskId1);
			});
		});
		
		describe("when all users have voted to quit", function() {
			beforeEach(function() {
				$('#end-vote').click();
				Chat.ws.onmessage(voteMessage1);
				Chat.ws.onmessage(voteMessage3);
			});

			it("moves on to the next page", function() {

			});
		});
	});
});
