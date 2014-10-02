var TemplateSupport = {
  highlight_answer: function() {
    // when any answer radiobutton changes state,
    // unhighlight all answers and then highlight selected one.
    // (Selected answer's index is the data-index property of the radiobutton.)
    $('.moocchat-choice').removeClass('answer-highlight');
    var myIndex = parseInt($(this).data('index'));
    $('.moocchat-choice').eq(myIndex).addClass('answer-highlight');
    $('.justify').attr('placeholder', 'Why did you choose ' + $(this).attr('value') + '?');
  },
  setup: function() {
    $('.choice-button').on('change', TemplateSupport.highlight_answer);
  }
};
$(TemplateSupport.setup);


    
