var web_socket = {
  group: null,
  ws: null,
  type: null, //both, vote, welcome
  sendChatMessageButton: null,
  voteButton: null,

  initialize: function(chatGroup,taskid,rails_mode, type) {
    this.type = type;
    if(typeof chatGroup == "number"){
    	this.group = [chatGroup];
    } else{
    	this.group = makeIntArray(chatGroup.split(','));
    }
    // create websocket
    var scheme= (rails_mode == 'production' ? 'wss://' : 'ws://');
    var uri = scheme + window.document.location.host + "/"+chatGroup+","+ taskid;
    this.ws = new WebSocket(uri);
    this.votes = new Array(this.group.length);
    this.voteButton = $('#vote-button');
    if(this.isBoth()){
      this.sendChatMessageButton = $('#send-chat-message');
    } else if(this.isVote()){
      this.voteButton.hide();
    }
    this.sendMessages();
    this.receiveMessages();
    this.taskid = taskid;
    console.log(this.type + this.taskid);
  },

  vote: function(taskid) {
    if(!contain(this.votes, taskid) & contain(this.group, taskid)){
      this.votes[this.group.indexOf(taskid)] = taskid;
    }
    if(compare(this.group, this.votes)){
      submitForm();
    }
  },


  receiveMessages: function() {
    var self = this;
    this.ws.onmessage = function(message) {
      var data = JSON.parse(message.data)
      if (data.type == "message" & self.isBoth()) {
        $("#chat-system").append("<blockquote class='moocchat-message system'><p>" + data.text + "</p></blockquote>")
      }
      if (data.type == "end-vote") {
        self.vote(data.taskid);
      }
    }
  },
  
  sendMessages: function() {
    var self = this;
    if(this.isBoth()){
      this.sendChatMessageButton.click(function(event) {
        event.preventDefault();
        var text   = $("#input-text")[0].value;
        self.ws.send(JSON.stringify({ text: text, taskid: self.taskid, type: "message" }));
        $("#input-text")[0].value = "";
      });
    }
    this.voteButton.click(function(event) {
      self.ws.send(JSON.stringify({ text: '', taskid: self.taskid, type: "end-vote" }));
    });
  },
  
  isBoth: function(){
  	return this.type == "both";
  },

  isVote: function(){
    return this.type == "vote";
  },

  setup: function() {
    var chats = $('#chat-box');
    var votes = $('#vote-box');
    if (chats.length > 0 && votes.length > 0){
      web_socket.initialize(chats.data('chatgroup'),chats.data('taskid'),chats.data('production'), "both");
    }else if(votes.length > 0){
      web_socket.initialize(votes.data('chatgroup'),votes.data('taskid'),votes.data('production'), "vote");
    } else{
      console.log("websocket is not initialized because unclear type");
      console.log("chat_length: " + chats.length);
      console.log("vote_length: " + votes.length);
    }
  },
};
$(web_socket.setup);

function submitForm() {
  // if there's a form generated by @start_form_tag macro, submit it
  if ($('form#_main').length > 0) {
    $('form#_main').submit();
  } 
};

function makeIntArray(stringArray){
  for(var i = 0; i < stringArray.length; i ++){
    stringArray[i] = parseInt(stringArray[i]);
  }
  return stringArray;
}

function contain(array, element){
  return array.indexOf(element) != - 1;
}

function compare(array1, array2){
  if(array1.length != array2.length){
    return false;
  }
  for(var i = 0; i < array1.length; i ++){
    if(array1[i] != array2[i]){
      return false;
    }
  }
  return true;
}