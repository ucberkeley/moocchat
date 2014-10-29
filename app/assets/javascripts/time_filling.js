/*$(document).ready(function(){
  var time_filler_carousel = $("#carousel-time-filler");
  console.log("#carousel-time-filler exists: " + time_filler_carousel.length);
  if(time_filler_carousel.length > 0){
    $("#carousel-time-filler").carousel();
  }
});*/


var time_filler = {
  time_filler: null,

  initialize: function(time_filler) {
    this.time_filler = time_filler
	$(document).ready(function(){
      time_filler.carousel();
    });
  },

  setup: function(){
    var time_filler_carousel = $("#carousel-time-filler");
    console.log("#carousel-time-filler exists: " + time_filler_carousel.length);
    if(time_filler_carousel.length > 0){
      //time_filler.initialize(time_filler_carousel);	
      //time_filler_carousel.carousel();
    }
  }
};
$(time_filler.setup);