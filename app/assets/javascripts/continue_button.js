var ContinueButton =  {
  //  bind a handler that will be called on form submission for rendered
  //  templates - but not for non-template (ie admin) page views.
  //  An admin page view is identified by the css class 'admin' on <body>.
  sendForm: function(event) {
    $('#interstitial').show();
    var form = $('form#_main');
    var submit_url = form.data('log-url');
    var form_data = form.serialize();
    $.ajax({
      type: 'POST',
      url: submit_url,
      data: form_data,
      error: ContinueButton.loggingError,
      success: ContinueButton.serverNotified
    });
    // disable the Submit button from multiple presses
    $('form#_main :submit').prop('disabled', true);
    event.preventDefault();
  },
  serverNotified: function() {
    $('body').addClass('serverNotified');
  },
  loggingError: function(xhrObject, textStatus, errorThrown) {
    alert(textStatus + " error on " + submit_url + ": " + errorThrown);
  },
  setup: function() {
    if ($('body').hasClass('admin')) {
      return;
    }
    $('#interstitial').hide();
    // $('body').on('click', ':submit', ContinueButton.sendForm);
    $(':submit').click(ContinueButton.sendForm);
  }
};

$(ContinueButton.setup);
