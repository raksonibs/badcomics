$(window).load(function() {

	$('body')
		.delay(500)
		.animate({ opacity: 0.75 }, 7000)
		.animate({ opacity: 1 }, 7000);

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
