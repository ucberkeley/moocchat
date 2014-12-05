// This script is responsible for showing the reminder at the top of
// each page in the course when an activity is about to begin.
//
// On the edX page, put (in production):
// <script>$.getScript("https://moocchat.herokuapp.com/moocchat_global_notification.js");</script><div id=moocchat></div>
// In testing:
// <script>$.getScript("https://cs1692x.moocforums.org/chatlog/moocchat_global_notification.js");</script>

divNowContent = '<div style="width: 100%; background-color: #eeffee; bottom; padding-bottom: 3px; margin-left:auto; margin-right:auto; border: 1px solid #88dd88; font-weight: bold; color: red;">The <a href="https://courses.edx.org/courses/BerkeleyX/CS-CS169.1x/3T2014/courseware/7ae5048e43664f2991f69feb03fda55d/d551a4346f5340f88acda9bbd5dd584c/1" target="_blank">Interactive Quiz 3 Review Activity Event (click to open in new tab)</a> is happening now. Please join us!</div>';

function timeIntervalToString(milliseconds) {
    seconds = Math.floor(milliseconds/1000);
    hours = Math.floor(seconds/(60*60));
    minutes = Math.floor((seconds - hours*60*60)/60);
    if (hours > 0) {
        return hours + "hr " + minutes + "min";
    } else if (minutes > 0) {
        return minutes + " min";
    } else if (seconds > 0) {
        return seconds + " sec";
    } else {
        return "0 sec";
    }
}

// Hide div during initialization to prevent submit button from being seen
$('#seq_content').prepend('<div id=moocchat_global_notification></div>');
$('.static_tab_wrapper').prepend('<div id=moocchat_global_notification></div>');

// Hard-coded session start/end times for now, refactor later
// Month is 0-11 so 11 is December
startSessionTime1 = Date.UTC(2014, 11, 5, 17, 30);
endSessionTime1 = Date.UTC(2014, 11, 5, 18, 00);
startSessionTime2 = Date.UTC(2014, 11, 6, 1, 30);
endSessionTime2 = Date.UTC(2014, 11, 6, 2, 30);

var interval;
var started = true; // Default to true so that the alert isn't shown repeatedly as they navigate between pages during the event

function update() {
    $.ajax({
        url:'https://moocchat.herokuapp.com/get_current_timestamp_utc/',
        dataType: 'jsonp',
        type: 'GET',
        contentType: "application/json",
        jsonpCallback: 'jsonCallback',
        success: function (json) {
            var now = json.current_timestamp_utc * 1000; // Convert sec to ms
            var divContent = divNowContent;
            if (now <= startSessionTime1) {
                started = false;
                diff1 = startSessionTime1 - now;
                diff2 = startSessionTime2 - now;
                divContent = '<div style="width: 100%; background-color: #eeffee; bottom; padding-bottom: 3px; margin-left:auto; margin-right:auto; border: 1px solid #88dd88;">The two Interactive Quiz 3 Review Activity events are occurring in ' + timeIntervalToString(diff1) + ' and ' + timeIntervalToString(diff2) + '. Plan to attend one if you can!</div>';
            } else if (now >= endSessionTime1 && now <= startSessionTime2) {
                started = false;
                diff2 = startSessionTime2 - now;
                divContent = '<div style="width: 100%; background-color: #eeffee; bottom; padding-bottom: 3px; margin-left:auto; margin-right:auto; border: 1px solid #88dd88;">The only remaining Interactive Quiz 3 Review Activity is occurring in ' + timeIntervalToString(diff2) +'. Plan to be there if you can!</div>';
            } else if (now > endSessionTime2) {
                // All over now, hide and cancel notification
                $("#moocchat_global_notification").hide();
                clearInterval(interval);
                return;
            } else {
                if (!started) {
                    alert("The Interactive Quiz 3 Review Activity has just started!\nClick the link in the green box at the top of\nthis page to join us now.");
                }
                started = true;
            }
            $("#moocchat_global_notification").html(divContent);
        }
    });
}

update();
interval = setInterval(function () {update();}, 15000);
