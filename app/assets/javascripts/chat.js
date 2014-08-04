var Chat = {
  ws: null,
  inputForm: null,

  initialize: function(chatGroup,taskid,rails_mode) {
    this.group = chatGroup;
    this.inputForm = $('#chat-input-form');
    // create websocket
    var scheme="";
    if (rails_mode== 'production'){
      scheme = 'wss://';
    }
    else{
      scheme = 'ws://';
    }

    var uri = scheme + window.document.location.host + "/"+chatGroup+","+ taskid;

    this.ws = new WebSocket(uri);
    this.inputForm.on('submit', Chat.handleSend);
    this.ws.onmessage = Chat.handleReceive;
  },
  handleReceive: function(message) {
    var data = JSON.parse(message.data);
    $("#chat-system").append("<div class='panel panel-default'><div class='panel-body'>" + data.text + "</div></div>")
  },
  handleSend: function(event) {
    var text   = $("#input-text")[0].value;
    event.preventDefault();
    Chat.ws.send(JSON.stringify({ text: text }));
    $("#input-text")[0].value = "";
  },
  setup: function() {
    var chats = $('#chat-box');
    if (chats.length > 0) {
      Chat.initialize(chats.data('chatgroup'),chats.data('taskid'),chats.data('production'));
    }
  },
};
$(Chat.setup);
