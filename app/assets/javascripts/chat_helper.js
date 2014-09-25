$(document).ready(function(){
    $('#input-text').keypress(function(e){
	    if(e.keyCode==13){
		    e.preventDefault();
	      $('#send-chat-message').click();
	    }
    });
});