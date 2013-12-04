
$(document).ready(function() {

	// Top nav slide down on load.
	$(".topnav").animate({ opacity: 0 }, 0);
	$(".topnav").delay(200).animate({top:"+=45", opacity: 1},1200);

	// top question and bottom statement fade-in on load.
	$(".question, .bottom").hide().delay(200).fadeIn(1200);

	// Category boxes animate from left to right on load.
	$(".categories").animate({ opacity: 0 }, 0);
	$(".categories").animate({left:"+=20", opacity: 1},1800);

	// This is where 6 new boxes need to be brought in.
	// Need to stop massive delay!!

	$(".categories1, .price, .question2, .question3").hide().animate({ opacity: 0 }, 0);

	var firstpick;
	var secondpick;
	var thirdpick;

	// $(".categories").one('click', function() {
	// 	var firstpick = $('#id').text();
	// 	alert(firstpick)
	// });

	$(".categories").one('click', function() {
		var firstpick = $(".categorybox").val();
  		$(".categories, .question").fadeOut( function() {
  			$(".categories1, .question2").show().animate({left:"+20", opacity: 1},1800);
  		});
  		
	});

	$(".categories1").one('click', function() {
		var secondpick = $(".categorybox").val(); 
  		$(".categories1, .question2").fadeOut( function() {
  			$(".price, .question3").show().animate({left:"+20", opacity: 1},1800);
  		});
  		
	});

	$(".price").one('click', function() {
		var thirdpick = $(".categorybox").val();
	});	

});