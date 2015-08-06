var ContinueButton =  {
  //  bind a handler that will be called on form submission for rendered
  //  templates - but not for non-template (ie admin) page views.
  //  An admin page view is identified by the css class 'admin' on <body>.
  submitUrl: '',
  sendForm: function(event) {
    $('#interstitial').show();
    var form = $('form#_main');
    this.submitUrl = form.data('log-url');
    var form_data = form.serialize();
    $.ajax({
      type: 'POST',
      url: this.submitUrl,
      data: form_data,
      error: this.loggingError,
      success: this.serverNotified
    });
    // disable the Submit button from multiple presses
    $('form#_main :submit').prop('disabled', true);
    event.preventDefault();

    // If there is no timer on this page (only permitted after final
    // chat stage is complete) submit form right away.
    if ($('#_timer_').length == 0) {
      $('form#_main').submit();
    }
  },
  clickVote: function() {
    $('#vote-button').click();
  },
  loggingError: function(xhrObject, textStatus, errorThrown) {
    alert(textStatus + " error on " + this.submitUrl + ": " + errorThrown);
  },
  serverNotified: function() {
    $('body').addClass('serverNotified');
  },
  setup: function() {
    // Don't intercept form submits on non-task-flow pages (in general, 
    // those are only available to admin users and have body.admin)
    if ($('body').hasClass('admin')) {
      return;
    }
    $('#interstitial').hide();
    $('#learning-button').on('click', ContinueButton.clickVote);
    $('body').on('click', ':submit:not(#send)', ContinueButton.sendForm);
  }
};

$(ContinueButton.setup);
