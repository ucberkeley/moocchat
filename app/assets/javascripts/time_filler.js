/*$(document).ready(function(){
  var time_filler_carousel = $("#carousel-time-filler");
  console.log("#carousel-time-filler exists: " + time_filler_carousel.length);
  if(time_filler_carousel.length > 0){
    $("#carousel-time-filler").carousel();
  }
});*/


var time_filler = {
  submitButton: null,
  carouselNext: null,

  initialize: function(submitButton, carouselNext) {
    console.log("yay")
    this.submitButton = submitButton;
    this.carouselNext = carouselNext;
  },

  setup: function(){
    var submitButton = $("#time_filler_submit");
    var answer = $("#timer_filler_answer");
    var carouselNext = $("#carousel_next");
    var carouselPrev = $("#carousel_prev");
    if(submitButton.length > 0 && answer.length > 0 && carouselNext.length > 0 && carouselPrev.length > 0){
      console.log("found all required buttons for time_filler");
      answer.hide();
      submitButton.hide();
      carouselPrev.hide();
      carouselNext.click(function(event){
        event.preventDefault();
        submitButton.show();
      });
      submitButton.click(function(event){
        event.preventDefault();
        answer.show();
      });
    }else{
      console.log("unable to find all required buttons to start time filler")
    }
  }
};
$(time_filler.setup);