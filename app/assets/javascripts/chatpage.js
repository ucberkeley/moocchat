var Chat = {
  group: '',
  ws: null,
  inputForm: null,
  task_id: '',

  initialize: function(chatGroup,taskid) {
    this.group = chatGroup;
    this.inputForm = $('#chat-input-form');
    // create websocket
    var scheme="";
    if ('<%= Rails.env %>'== 'production'){
      scheme = 'wss://';
    }
    else{
      scheme = 'ws://';
    }

    var uri = scheme + window.document.location.host + "/"+chatGroup+","+ taskid;

    this.ws = new WebSocket(uri);
    this.sendMessages();
    this.receiveMessages();
    
  },

  receiveMessages: function() {

    this.ws.onmessage = function(message) {
      var data = JSON.parse(message.data)
      //if (data.group == this.group){
      $("#chat-system").append("<div class='panel panel-default'><div class='panel-body'>" + data.text + "</div></div>")
      //}
    }
  },

  sendMessages: function() {
    var self = this
    this.inputForm.on("submit", function(event) {
    //$("#chat-input-form").on("submit", function(event) {
      event.preventDefault();
      var text   = $("#input-text")[0].value;
      self.ws.send(JSON.stringify({ text: text }));
      $("#input-text")[0].value = "";
    });
  },
  setup: function() {
    var chats = $('#chat-box');
    if (chats.length > 0) {
      Chat.initialize(chats.data('chatgroup'),chats.data('taskid'));

    }
  },
};
$(Chat.setup);