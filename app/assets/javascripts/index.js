$(window).load(function() {

	// $('body')
	// 	.delay(1000)
	// 	.animate({ opacity: 0.8 }, 7000)
	// 	.animate({ opacity: 1 }, 7000);

	// $(".container").one("mouseover", function() {
	// 	$(".container")
	// 		.delay(3000)
	// 		.addClass('permahover');
	// });

	$(".topnav1")
	    .animate({
	      opacity: 0 }, 0)
	    .delay(200)
	    .animate({
	      top:"+=45",
	      opacity: 1},1500);

	$('.recommend')
		.animate({ opacity: 0 }, 0)
		.delay(200)
	    .animate( {
	      width:"25%",
	      opacity: 1}, 1500, function () {
	      	$('.rightfade').fadeIn(700);
	    	}
	    );

	// , function(){
 //    	$(this).css({backgroundImage : "url(toronto_skyline.jpg)"});
 //    	$(this).fadeIn(1000);
	// });

});
