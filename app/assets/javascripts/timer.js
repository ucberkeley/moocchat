var Timer = {
  seconds: 0,
  selectorToUpdate: '#_timer_',
  nextTimeout: null,
  updateDisplay: function() {
    var min = Math.floor(this.seconds/60).toString();
    var sec = (this.seconds % 60).toString();
    var displayTime = (min<10 ? '0': '') + min + ':' + (sec<10 ? '0' : '') + sec;
    $(this.selectorToUpdate).text(displayTime);
  },
  initialize: function(seconds) {
    this.seconds = seconds;
    this.updateDisplay();
    this.countdown();
  },
  countdown: function() {
    this.nextTimeout = setTimeout('Timer.decrement()', 1000);
  },
  submitForm: function() {
    clearTimeout(this.nextTimeout);
    $('form:first').submit();
  },
  decrement: function() {
    this.seconds -= 1;
    this.updateDisplay();
    if (this.seconds > 0) {
      this.countdown();
    } else {
      this.submitForm();
    }
  },
};
$(function() {
  // bind a new Timer to any element whose selector matches '#_timer_'
  var t = $('#_timer_');
  if (t.length > 0) { // the page has a timer on it
    Timer.initialize(t.data('countfrom'));
  }
});
