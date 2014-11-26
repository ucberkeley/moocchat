// This script is responsible for showing the reminder at the top of
// each page in the course when an activity is about to begin.
//
// On the edX page, put (in production):
// <script>$.getScript("https://moocchat.herokuapp.com/moocchat_global_notification.js");</script><div id=moocchat></div>
// In testing:
// <script>$.getScript("https://cs1692x.moocforums.org/chatlog/moocchat_global_notification.js");</script>

divContent =
['<div style="width: 100%; background-color: #eeffee; bottom; padding-bottom: 3px; margin-left:auto; margin-right:auto; border: 1px solid #88dd88;">An <a href="https://courses.edx.org/courses/BerkeleyX/CS-CS169.1x/3T2014/courseware/f6051cd6450e445cb285f43467bd1de9/d551a4346f5340f88acda9bbd5dd584c/1" target="_blank">interactive quiz 2 review activity (click to open in new tab)</a> is starting in less than 3 minutes.</div>'
].join('\n');

// Hide div during initialization to prevent submit button from being seen
$('#seq_content').prepend('<div id=moocchat_global_notification></div>');
$("#moocchat_global_notification").hide();
$("#moocchat_global_notification").html(divContent);

function update() {
    $.ajax({
        url:'https://moocchat.herokuapp.com/seconds_to_next_group_formation/10/',
        dataType: 'jsonp',
        type: 'GET',
        contentType: "application/json",
        jsonpCallback: 'jsonCallback',
        success: function (json) {
            if (json.seconds_to_next_group_formation < 3*60) {
                $("#moocchat_global_notification").show();
            } else {
                $("#moocchat_global_notification").hide();
            }
        }
    });
}

update();
setInterval(function () {update();}, 30000);
