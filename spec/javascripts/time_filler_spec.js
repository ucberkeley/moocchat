describe("time filler", function() {

  describe("first carousel page", function(){
    beforeEach(function() {
      var fixture = $(
        '<div id="this-carousel-id" class="carousel slide" data-interval="false">' +
          '<div class="carousel-inner">' +
            '<div class="item active first">' +
              '<h1>Lets try a few time filler questions!</h1>' +
              '<h3>press the Next Question button on the top right corner.</h3>' +
            '</div>' +
          '<button id="time_filler_submit" class="btn btn-lg btn-primary submit">Submit Answer</button>' +
          '</div><!-- /.carousel-inner -->' +
          '<a id="carousel_prev" class="carousel-control left" href="#this-carousel-id" data-slide="prev">&lsaquo;</a>' +
          '<a id="carousel_next" class="carousel-control right" href="#this-carousel-id" data-slide="next">&rsaquo; Next Question</a>' +
        '</div><!-- /.carousel -->'
      );
      setFixtures(fixture);
      time_filler.setup();
    });

    it ('hides the submit button', function() {
      expect($('#time_filler_submit'))
    });
  });

  describe("the first question", function() {

    beforeEach(function() {
      var fixture = $(
        '<div id="this-carousel-id" class="carousel slide" data-interval="false">' +
          '<div class="carousel-inner">' +
            '<div class="item active">' +
              '<div>Question 1 Text</div>' +
              '<div id="timer_filler_answer" class="col-md-7 answer"><h4>The answer is A</h4></div>' +
              '<div class="row answer-box-js">' +
                '<div class="moocchat-choice-area moocchat-conditional answer-box">' +
                  '<div class="llist-group-item active moocchat-probing-question-choice answer-box1">' +
                    '<div class="list-group-item moocchat-choice moocchat-choice-0 answer-box">' +
                      '<input class="choice-button" data-index="0" id="u_choice_A" name="u[choice]" type="radio" value="A">' +
                      '<div class="moocchat-choice-box moocchat-choice-box-0 letter-box letter-box-0">A</div>' +
                      '<label for="u_choice_A" class="list-group-item-heading moocchat-choice-statement">' +
                        'This is an answer statement' +
                      '</label>' +
                    '</div>' +
                  '</div>' +
                '</div>' +
              '<div class="moocchat-choice-area moocchat-conditional answer-box">' +
                '<div class="llist-group-item active moocchat-probing-question-choice answer-box1">' +
                  '<div class="list-group-item moocchat-choice moocchat-choice-1 answer-box">' +
                    '<input class="choice-button" data-index="1" id="u_choice_B" name="u[choice]" type="radio" value="B">' +
                    '<div class="moocchat-choice-box moocchat-choice-box-1 letter-box letter-box-1">B</div>' +
                    '<label for="u_choice_B" class="list-group-item-heading moocchat-choice-statement">' +
                      'This is another answer statement' +
                    '</label>' +
                  '</div>' +
                '</div>' +
              '</div>' +
            '</div>' +
          '<button id="time_filler_submit" class="btn btn-lg btn-primary submit">Submit Answer</button>' +
          '</div><!-- /.carousel-inner -->' +
          '<a id="carousel_prev" class="carousel-control left" href="#this-carousel-id" data-slide="prev">&lsaquo;</a>' +
          '<a id="carousel_next" class="carousel-control right" href="#this-carousel-id" data-slide="next">&rsaquo; Next Question</a>' +
        '</div><!-- /.carousel -->'
      );
      setFixtures(fixture);
      time_filler.setup();
    });

    it("displays the second question", function() {
      expect($(".active")).toContainText("Question 1 Text");
    });

    it("originally hides the answer", function(){
      expect($('.answer')).toBeHidden();
    });

    it("shows the answer on clicking submit", function() {
      $("#time_filler_submit").click()
      expect($('.answer')).toBeVisible();
    });
  });
});
