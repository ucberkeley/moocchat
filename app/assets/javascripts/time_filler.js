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
    this.submitButton = submitButton;
    this.carouselNext = carouselNext;
  },

  setup: function(){
    var submitButton = $("#time_filler_submit");
    var answer = $(".answer");
    var carouselNext = $("#carousel_next");
    var carouselPrev = $("#carousel_prev");
    if(carouselNext.length > 0 && carouselPrev.length > 0){
      answer.hide();
      submitButton.hide();
      carouselPrev.hide();
      carouselNext.click(function(event){
        event.preventDefault();
        answer.hide();
        submitButton.show();
        setTimeout(function() {
          if ($('.active').hasClass('first')) {
            submitButton.hide();
          }
        },1000);
      });
      submitButton.click(function(event){
        event.preventDefault();
        answer.show();
      });
    }
  }
};
$(time_filler.setup);
