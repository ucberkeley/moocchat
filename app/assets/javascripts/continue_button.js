var ContinueButton =  {
  //  bind a handler that will be called on form submission for rendered
  //  templates - but not for non-template (ie admin) page views.
  //  An admin page view is identified by the css class 'admin' on <body>.
  ajaxSubmit: function() {
    $('#interstitial').show();
  },
  setup: function() {
    if ($('body').hasClass('admin')) {
      return;
    }
    $('#interstitial').hide();
    $('body').on('submit', 'form', ContinueButton.ajaxSubmit);
  }
};

$(ContinueButton.setup);
