// Handles consent. Embedded in edX using:
// Testing: <script>$.getScript("https://cs1692x.moocforums.org/chatlog/edxframe/CS169.1x/3T2014/consent.js");</script>
// Production: <script>$.getScript("https://moocchat.herokuapp.com/consent.js");</script>

var urlPrefix = 'https://moocchat.herokuapp.com/';
// var scriptPrefix = 'https://cs1692x.moocforums.org/chatlog/edxframe/CS169.1x/3T2014/' // For testing
var scriptPrefix = urlPrefix; // For production

$.getScript(scriptPrefix + 'util.js', function(){

function recordConsent(val) {
  $.ajax({
      url: urlPrefix + 'users/record_consent/',
      dataType: 'jsonp',
      data: {username: getUsername(), consent: val},
      type: 'GET',
      success: function () {
          alert("Your response has been recorded.");
      }
  });
}

$("#responses1").hide();
$("#responses2").hide();

$("#consentaccept1").click(function(){ recordConsent(true); });
$("#consentreject1").click(function(){ recordConsent(false); });
$("#consentaccept2").click(function(){ recordConsent(true); });
$("#consentreject2").click(function(){ recordConsent(false); });

$.ajax({
    url: urlPrefix + 'users/check_consent/',
    data: {username: getUsername()},
    dataType: 'jsonp',
    type: 'GET',
    contentType: "application/json",
    jsonpCallback: 'jsonCallback',
    success: function (json) {
        if (json.completed) {
            alreadyCompleteMessage = "<b>You have already completed this consent form. Please proceed to the activity.</b>";
            $("#responses1").html(alreadyCompleteMessage);
            $("#responses2").html(alreadyCompleteMessage);
        }
        $("#responses1").show();
        $("#responses2").show();
    }
    // TODO: handle error case, show error message
});

}); // $.getScript('util.js', function(){
