// edxbootstrap is loaded and executed directly in the edX domain
// using the following JS code fragment in an HTML or Text block:
//
// <script>$.getScript("https://moocchat.herokuapp.com/edxbootstrap.js");</script><div id=moocchat></div>
//
// It is responsible for embedding the MOOCchat app in edX, and
// retrieving any needed information such as username from the edX DOM
// and passing it along to MOOCchat.

// entityMap and escapeHtml from http://stackoverflow.com/a/12034334/724491
var entityMap = {
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': '&quot;',
    "'": '&#39;',
    "/": '&#x2F;'
};

function escapeHtml(string) {
    return String(string).replace(/[&<>"'\/]/g, function (s) {
        return entityMap[s];
    });
}

// getContentInContainer based on http://stackoverflow.com/a/3808886/724491
// Finds and gets content of tag having a specific class
function getContentInContainer(matchClass) {
    var elems = document.getElementsByTagName('*'), i;
    for (i in elems) {
        if((' ' + elems[i].className + ' ').indexOf(' ' + matchClass + ' ')
                > -1) {
            return elems[i].textContent;
        }
    }
}

// Note: This scrapes the edX DOM - replace if/when possible with a web service API query.
function getUsername() {
  var n = getContentInContainer("user-link").replace("Dashboard for:", "").replace(/^\s+|\s+$/g, '');
  if (!isNaN(n[0])) {
     n = "_" + n;
  }
  return n;
}

divContent =
['<form id="moocchat_form" action="https://moocchat.herokuapp.com/tasks" method="post" target="moocchat_iframe">',
 '  <input type="submit" value="SUBMIT" />',
 '  <input type="hidden" name="learner_name" value="' + escapeHtml(getUsername()) + '" />',
 '  <input type="hidden" name="condition_id" value="3" />',
 '  <input type="hidden" name="activity_schema_id" value="3" />',
 '</form>',
 '<iframe name="moocchat_iframe" src="javascript:void(0)" height="550" width="100%"></iframe>'
].join('\n');

// Hide div during initialization to prevent submit button from being seen
$("#moocchat").hide();
$("#moocchat").html(divContent);
$("#moocchat_form").hide();
$("#moocchat_form").submit();
$("#moocchat").show();
