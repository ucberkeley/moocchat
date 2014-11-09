ActivitySchema = {
  hideUnusedQuestions: function() {
    var count = $('#activity_schema_num_questions').val();
    for (var i=0; i < count; i++) {
      $('#questions' + i).show();
    }
    for (var i = count; i < 35; i++) {
      $('#questions' + i).hide();
    }
  },
  setup: function() {
    $('#activity_schema_num_questions').change(ActivitySchema.hideUnusedQuestions);
    ActivitySchema.hideUnusedQuestions();
  }
};
$(ActivitySchema.setup);
