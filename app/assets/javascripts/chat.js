var Chat = {
  group: null,
  ws: null,
  sendChatMessageButton: null,
  voteButton: null,

  initialize: function(chatGroup,taskid,rails_mode) {
    this.group = chatGroup.split(',');
    this.votes = new Array(this.group.length);

    // create websocket
    var scheme= (rails_mode == 'production' ? 'wss://' : 'ws://');
    var uri = scheme + window.document.location.host + "/"+chatGroup+","+ taskid;
    this.sendChatMessageButton = $('#send-chat-message');
    this.voteButton = $('#end-vote');
    this.ws = new WebSocket(uri);
    this.sendMessages();
    this.receiveMessages();
    this.vote();
    this.taskid = taskid;

  },

  vote: function(userId) {
    var allTrue = true;
    for (i =0; i < this.group.length; i++) {
      if (this.group[i] == userId) {
        this.votes[i] = true;
      }
      
      if (!this.group[i]) {
        allTrue = false;
      }
    }
    if (allTrue) {
      //TODO: navigate to the next page
    }
  },

  receiveMessages: function() {
    var self = this;
    this.ws.onmessage = function(message) {
      var data = JSON.parse(message.data)
      if (data.type == "message") {
        $("#chat-system").append("<blockquote class='moocchat-message system'><p>" + data.text + "</p></blockquote>")
      }
      if (data.type == "end-vote") {
        self.vote(data.taskid);
      }
    }
  },
  
  sendMessages: function() {
    var self = this;
    this.sendChatMessageButton.click(function(event) {
      event.preventDefault();
      var text   = $("#input-text")[0].value;
      self.ws.send(JSON.stringify({ text: text, taskid: self.taskid, type: "message" }));
      $("#input-text")[0].value = "";
    });

    this.voteButton.click(function(event) {
      self.ws.send(JSON.stringify({ text: '', taskid: self.taskid, type: "end-vote" }));
      self.vote(self.taskid);
    });
  },
  
  setup: function() {
    var chats = $('#chat-box');
    if (chats.length > 0) {
      Chat.initialize(chats.data('chatgroup'),chats.data('taskid'),chats.data('production'));
    }
  },
};
$(Chat.setup);
