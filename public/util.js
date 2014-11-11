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

function getUsername() {
  return getContentInContainer("user-link").replace("Dashboard for:", "").replace(/^\s+|\s+$/g, '');
}

function sendJsonpCommand(url) {
    $.ajax({
	url: url,
	dataType: 'jsonp',
	type: 'GET',
	contentType: "application/json",
	jsonpCallback: 'jsonCallback',
	success: function (json) { }
    });
}

function sendJsonpCommandThen(url, data, successFunc) {
    $.ajax({
        url: url,
        dataType: 'jsonp',
        data: data,
        type: 'GET',
        async: false,
        contentType: "application/json",
        jsonpCallback: 'jsonCallback',
        success: successFunc
    });
}
