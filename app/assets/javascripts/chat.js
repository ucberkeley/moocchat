  var Chat = {
  group: null,
  ws: null,
  sendChatMessageButton: null,

  initialize: function(chatGroup,taskid,rails_mode) {
    this.group = chatGroup;
    // create websocket
    var scheme= (rails_mode == 'production' ? 'wss://' : 'ws://');
    var uri = scheme + window.document.location.host + "/"+chatGroup+","+ taskid;
    this.sendChatMessageButton = $('#send-chat-message');
    this.ws = new WebSocket(uri);
    this.sendMessages();
    this.receiveMessages();
    this.taskid = taskid;
  },

  receiveMessages: function() {

    this.ws.onmessage = function(message) {
      var data = JSON.parse(message.data)
      if (data.type == "message") {
        $("#chat-system").append("<blockquote class='moocchat-message system'><p>" + data.text + "</p></blockquote>")
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
  },
  
  setup: function() {
    var chats = $('#chat-box');
    if (chats.length > 0) {
      Chat.initialize(chats.data('chatgroup'),chats.data('taskid'),chats.data('production'));

    }
  },
};
$(Chat.setup);
