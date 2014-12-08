var web_socket = {
  
  group: null,
  ws: null,
  type: null, //both, vote, welcome
  sendChatMessageButton: null,
  voteButton: null,
  lastHeartbeatMap: null,
  heartbeatTimeMs: 10000,
  heartbeatTimeoutMs: 29000,

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

    // Create heartbeat map and initialize to current time in case we
    // never receive a heartbeat from a group member
    this.lastHeartbeatMap = new Object();
    var currentTime = new Date().getTime();
    for(var i = 0; i < this.group.length; i++) {
      if (this.group[i] != this.taskid) {
        this.lastHeartbeatMap[this.group[i]] = currentTime;
      }
    }

    if(this.isBoth()){
      this.sendChatMessageButton = $('#send-chat-message');
    } else if(this.isVote()){
      this.voteButton.hide();
    }
    this.sendMessages();
    this.receiveMessages();
    this.taskid = taskid;

    var self = this;
    this.ws.onclose = function(evt) {
      if (!evt.wasClean) {
        console.log("WebSocket connection closed abnormally, onclose: code: " + evt.code + ", reason: " + evt.reason);
      }
    };
    this.ws.onerror = function(evt) {
      console.log("WebSocket onerror: evt.data: " + evt.data);
    };

    this.showWelcomeMessage();
  },

  checkVote: function() {
    if(arrays_equal(this.group, this.votes)){
      submitForm();
    }
  },

  vote: function(taskid) {
    if(!contain(this.votes, taskid) & contain(this.group, taskid)){
      this.votes[this.group.indexOf(taskid)] = taskid;
    }
    this.checkVote();
  },

  disconnect: function(other_taskid) {
    var position = this.group.indexOf(other_taskid);
    console.log("Received disconnect notification for task " + other_taskid + " (position " + position + ")");
    if (position == -1) { // Already removed (defensive check)
      return;
    }
    // Remove departed learner from group and votes
    this.group.splice(position, 1);
    this.votes.splice(position, 1);

    // First member of the remaining group is responsible for sending quit message
    // Small bug: Message may be lost if two quit at exact same time
    if (this.taskid == this.group[0])
    {
      this.ws.send(JSON.stringify({ text: "has disconnected", taskid: other_taskid, type: "message" }));
    }
    // Report disconnection to server (server may receive multiple reports)
    // TODO: error handling
    $.ajax({type: "POST", url: "/tasks/" + other_taskid + "/disconnect"});

    this.checkVote(); // the disconnecting learner may have been the last one who didn't vote, in which case proceed
  },

  showMessage: function(text) {
    if ($("#chat-system").length) {
      $("#chat-system").append("<blockquote class='moocchat-message system'><p>" + text + "</p></blockquote>");
      $("#chat-system").scrollTop($("#chat-system")[0].scrollHeight); // ensure automatic scroll to bottom of chat window
    }
  },

  receiveMessages: function() {
    var self = this;
    this.ws.onmessage = function(message) {
      var data = JSON.parse(message.data)
      if (data.type == "message" & self.isBoth()) {
        self.showMessage(data.text);
      }
      if (data.type == "end-vote") {
        self.vote(data.taskid);
      }
      if (data.type == "disconnect") { 
        self.disconnect(data.taskid);
      }
      if (data.type == "heartbeat" && data.taskid != self.taskid) {
        var currentTime = new Date().getTime();
        self.lastHeartbeatMap[data.taskid] = currentTime;
      }
    };
  },
  
  sendMessages: function() {
    var self = this;
    if(this.isBoth()){
      this.sendChatMessageButton.click(function(event) {
        event.preventDefault();
        var text   = $("#input-text")[0].value;
        self.ws.send(JSON.stringify({ text: text, taskid: self.taskid, type: "message" }));
        $("#input-text")[0].value = "";
        self.sendLog(self.taskid, "chat", text);
      });
    }
    this.voteButton.click(function(event) {
      self.ws.send(JSON.stringify({ text: "has voted to quit chat", taskid: self.taskid, type: "message" }));
      self.ws.send(JSON.stringify({ text: '', taskid: self.taskid, type: "end-vote" }));
      self.sendLog(self.taskid, "quit_chat", "");
      return false;
    });

    window.setInterval(function(message) {
      self.ws.send(JSON.stringify({ text: '', taskid: self.taskid, type: "heartbeat" }));
      var currentTimeMs = new Date().getTime();
      for(var i = 0; i < self.group.length; i++) {
        other_taskid = self.group[i];
        if (other_taskid != self.taskid) {
          if (self.lastHeartbeatMap[other_taskid] < currentTimeMs - self.heartbeatTimeoutMs) {
            console.log("Task " + other_taskid + " has disconnected (heartbeat not received for " + self.heartbeatTimeoutMs + " ms)");
            self.disconnect(other_taskid);
            break;
          }
        }
      }
    }, this.heartbeatTimeMs);
  },
  
  sendLog: function(taskid, name, value){
    log_data = { name: name, value: value };
    $.ajax({
        type: "POST",
        url: "/tasks/" + taskid + "/log",
        data: log_data,
        success: function(data, textStatus, jqXHR){
            console.log("sucessfully logged " + name);
        },
        error: function (data, textStatus, jqXHR){
            console.log("fail to log " + name);
        }
    });
  },

  isBoth: function(){
    return this.type == "both";
  },

  isVote: function(){
    return this.type == "vote";
  },

  showWelcomeMessage: function(){
    if (this.group.length == 1) {
      this.showMessage("No one is currently available to chat with you. You may use this chatroom to reflect on the question. Click the end button above when done.");
    } else if (this.group.length == 2) {
      var you_learner = '';
      var learner = '';
      for(var i = 0; i < this.group.length; i++) {
          if (this.group[i] == this.taskid) {
            you_learner = i + 1;
          } else  {
            learner = i + 1;
          }
      }
      this.showMessage("You are Learner " + you_learner + ". Learner " + learner + " is also here.");
    } else if (this.group.length == 3) {
      var you_learner = '';
      var learners = '';
      for(var i = 0; i < this.group.length; i++) {
          if (this.group[i] == this.taskid) {
            you_learner = i + 1;
          } else if (this.group[i] != this.taskid) {
              if (learners == '') {
                learners = i + 1;
              } else {
                learners = learners + " and " + (i + 1);
              }
          }
      }
      this.showMessage("You are Learner " + you_learner + ". Learners " + learners + " are also here.");
    }
  },

  setup: function() {
    var chats = $('#chat-box');
    var votes = $('#vote-box');
    if (chats.length > 0 && votes.length > 0){
      web_socket.initialize(chats.data('chatgroup'),chats.data('taskid'),chats.data('production'), "both");
    }else if(votes.length > 0){
      web_socket.initialize(votes.data('chatgroup'),votes.data('taskid'),votes.data('production'), "vote");
    } else{
      // No chat-box or vote-box on this page, don't initialize websocket
    }
  }
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

function arrays_equal(array1, array2){
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
