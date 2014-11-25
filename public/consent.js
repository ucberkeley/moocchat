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

$("#consentaccept1").hide();
$("#consentreject1").hide();
$("#consentaccept2").hide();
$("#consentreject2").hide();

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
            $("#consentaccept1").html("<b>You have already completed this consent form. Please proceed to the activity.</b>");
            $("#consentreject1").html("&nbsp;");
            $("#consentaccept2").html("<b>You have already completed this consent form. Please proceed to the activity.</b>");
            $("#consentreject2").html("&nbsp;");
        }
        $("#consentaccept1").show();
        $("#consentreject1").show();
        $("#consentaccept2").show();
        $("#consentreject2").show();
    }
});

}); // $.getScript('util.js', function(){
