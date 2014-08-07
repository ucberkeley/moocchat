var AnswerChoicesTemp={
	setup: function() {
		var ans = $('.answer-box-js');
		if (ans.length > 0){	
    		$('.answer-box').click(function(evt){
    			
				var tempAnswerA = $('.letter-box-0').html();
				var tempAnswerB = $('.letter-box-1').html();
				var tempAnswerC = $('.letter-box-2').html();
				var tempAnswerD = $('.letter-box-3').html();
				var tempAnswerE = $('.letter-box-4').html();

				if(tempAnswerA=='X'){
					$('.letter-box-0').html('A');
				}
				if(tempAnswerB=='X'){
					$('.letter-box-1').html('B');
				}
				if(tempAnswerC=='X'){
					$('.letter-box-2').html('C');
				}
				if(tempAnswerD=='X'){
					$('.letter-box-3').html('D');
				}
				if(tempAnswerE=='X'){
					$('.letter-box-4').html('E');
				}

				var tempAnswer = $(this).children('.letter-box').html();
				$(this).children('.letter-box').html('X');
				$('.justify').attr('placeholder','Why did you choose '+tempAnswer+'?');
				evt.stopPropagation();
				evt.preventDefault();
			});
		}
  	},
};
$(AnswerChoicesTemp.setup);