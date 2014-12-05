// Handles consent. Embedded in edX using:
// Testing: <script>$.getScript("https://cs1692x.moocforums.org/chatlog/edxframe/CS169.1x/3T2014/consent.js");</script><div id=moocchat></div>
// Production: <script>$.getScript("https://moocchat.herokuapp.com/consent.js");</script><div id=moocchat></div>

var urlPrefix = 'https://moocchat.herokuapp.com/';
// var scriptPrefix = 'https://cs1692x.moocforums.org/chatlog/edxframe/CS169.1x/3T2014/' // For testing
var scriptPrefix = urlPrefix; // For production

$.getScript(scriptPrefix + 'util.js', function(){

$("#moocchat").hide();

// if (document.getElementById('dialog-consent-details')) {
init();
// } else {
//   window.onload = init;
// }

function showChat(condition_id, activity_schema_id) {
    divContent =
        ['<form id="moocchat_form" action="' + urlPrefix + 'tasks" method="post" target="moocchat_iframe">',
         '  <input type="submit" value="SUBMIT" />',
         '  <input type="hidden" name="learner_name" value="edX user ' + escapeHtml(getUsername()) + '" />',
         '  <input type="hidden" name="condition_id" value="' + condition_id + '" />',
         '  <input type="hidden" name="activity_schema_id" value="' + activity_schema_id + '" />',
         '</form>',
         '<iframe name="moocchat_iframe" src="javascript:void(0)" height="550" width="100%"></iframe>'
        ].join('\n');

    // Hide div during initialization to prevent submit button from being seen
    $("#moocchat").hide();
    $("#moocchat").html(divContent);
    $("#moocchat_form").hide();
    $("#moocchat_form").submit();
    $("#moocchat").show();
}

function init() {
  // Based on http://www.jquery4u.com/json/jsonp-examples/
  $.ajax({
      url: urlPrefix + 'users/check_consent/',
      data: {username: getUsername()},
      dataType: 'jsonp',
      type: 'GET',
      contentType: "application/json",
      jsonpCallback: 'jsonCallback',
      success: function (json) {
          if (!json.completed) {
              $("#moocchat").html("<p>You have not yet completed the consent form for this activity. Please complete it and then visit this page again.</p>");
              $("#moocchat").show();
          } else if (json.consented) {
              showChat(8, 14);
          } else {
              showChat(9, 16);
          }
      }
  });
}

}); // $.getScript('util.js', function(){
