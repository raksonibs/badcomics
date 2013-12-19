$(function() {

	$(".lightbox").fadeIn( function() {
		$(".hellomsg")
			.delay(200)
			.fadeIn(400, function() {
				$(".shortds, .fbbuttonpos, .theapp").fadeIn(400);
			});
	});

});