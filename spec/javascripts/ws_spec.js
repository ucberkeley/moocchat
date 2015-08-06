describe("chat socket", function() {
	
	var chatGroup = "1,2,3";
	var groupList = [1, 2, 3];
	var votes = [false, false, false];
	var taskID = 2; //current user
	var otherTaskId1 = 1; // another user
	var otherTaskId3 = 3;
	var prodcution = "test";
	var hello = "Hello World";
	var chatJSON = JSON.stringify({ text : hello, taskid: taskID, type: "message" });
	var sendEndVoteMessageJSON = JSON.stringify({ text : "has voted to quit chat", taskid: taskID, type: "message" });
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

		spyOn($, 'ajax').and.returnValue(function(params) { return {type: params.type, url: params.url, data: parmas.data }}); // CHANGE THIS VALUE

		spyOn(web_socket, 'sendMessages').and.callThrough();
		spyOn(web_socket, 'vote').and.callThrough();
		spyOn(web_socket, 'sendLog').and.callThrough();

		var fixture = $('<div id="chat-box" class="container" data-chatgroup=' + chatGroup + ' data-taskid=' + taskID + 
			' data-production=' + prodcution + '> ' + 
			'<div class="form-group">' +
				'<input id="input-text" type="text" class="form-control" placeholder="Enter chat text here!" autofocus />' +
				'<button id="send-chat-message" class="btn btn-primary" type="submit">Send</button>' +
				
				'<div id="vote-box" data-chatgroup="1,2,3" data-taskid = "2" data-production = <%=Rails.env%>>' +
                	'<button id="vote-button" class="col-sm-6 col-sm-offset-1 btn btn-lg moocchat-next-button btn-danger">Vote to move on</button>' +
				'</div>'+

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
    web_socket.setup();

	});
	
	describe("Initialization", function() {
		it("initializes websocket", function() {
			expect(window.WebSocket).toHaveBeenCalled();
			expect(web_socket.ws).not.toBeNull();
		});

		it("initializes group correctly", function() {
			expect(web_socket.group).toEqual(groupList);
		});
		
		it("finds Send Message button", function() {
			expect(web_socket.sendChatMessageButton).not.toBeNull();
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
				expect(web_socket.sendMessages).toHaveBeenCalled();
				expect(this.sendSpy).toHaveBeenCalledWith(chatJSON);
			});
			
			it('sends the correct message', function() {
				expect(this.sendSpy).toHaveBeenCalledWith(chatJSON);
			});

			it('logs the chat message', function() {
				expect(web_socket.sendLog).toHaveBeenCalledWith(2, "chat", "Hello World");
				var args = $.ajax.calls.first().args[0];
				expect(args.type).toEqual('POST');
				expect(args.url).toEqual('/tasks/2/log');
				expect(args.data).toEqual({ name : 'chat', value : 'Hello World' });

			});
		});

		describe("receiving chat", function() {
			describe("chat message", function() {
				beforeEach(function() {
					web_socket.ws.onmessage(chatMessage);
				});

				it('appends message to the chat', function() {
					expect($('#chat-system')).toContainText("Hello World");
				});

				it('does not change any vote statuses', function() {
					expect(web_socket.vote).not.toHaveBeenCalledWith(taskID);
				})
			});
		});
	});

	describe("Voting to end chat", function() {
		describe("sending vote", function() {
			beforeEach(function() {
				$('#vote-button').click();
			});

			it('sends the message to the server', function() {
				expect(this.sendSpy).toHaveBeenCalledWith(sendEndVoteJSON);
				expect(this.sendSpy).toHaveBeenCalledWith(sendEndVoteMessageJSON);
			});

			it('logs the vote', function() {
				expect(web_socket.sendLog).toHaveBeenCalledWith(2, "quit_chat", "");
				var args = $.ajax.calls.first().args[0];
				expect(args.type).toEqual('POST');
				expect(args.url).toEqual('/tasks/2/log');
				expect(args.data).toEqual({ name : 'quit_chat', value : '' });
			});
		});

		describe("receiving vote", function() {
			beforeEach(function() {
				web_socket.ws.onmessage(voteMessage1);
			});

			it("marks the user as finished", function() {
				expect(web_socket.vote).toHaveBeenCalledWith(otherTaskId1);
			});
		});
		
		describe("when all users have voted to quit", function() {
			beforeEach(function() {
				$('#vote-button').click();
				web_socket.ws.onmessage(voteMessage1);
				web_socket.ws.onmessage(voteMessage3);
			});

			it("moves on to the next page", function() {

			});
		});
	});
});
