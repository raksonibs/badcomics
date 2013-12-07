
$(window).load(function() {
  
	// Top nav slide down on load.
	$(".topnav").animate({ opacity: 0 }, 0);
	$(".topnav").delay(200).animate({top:"+=45", opacity: 1},1500);

	// top question and bottom statement fade-in on load.
	$(".question, .bottom").hide().delay(100).fadeIn(800);

	// Category boxes animate from left to right on load.
	$(".categories").animate({ opacity: 0 }, 0);
	$(".categories").animate({left:"+=20", opacity: 1},800);
  


	// This is where 6 new boxes need to be brought in.
	// Need to stop massive delay!! Maybe roll back to old version?

	$(".categories1, .price, .output, .question2, .question3, .question4").hide().animate({ opacity: 0 });
	
	$(".categories").one('click', function(e) {
   		$(".categories, .question").fadeOut( function() {
           	$(".categories1, .question2").show().animate({left:"+15", opacity: 1},800);
       	});
       	e.stopPropogation();
   	});

	$(".categories1").on('click', function(e) {
  		$(".categories1, .question2").fadeOut( function() {
  			$(".price, .question3").show().animate({left:"+15", opacity: 1}, 800);
  		});
  		e.stopPropogation();
	});

	$(".categories1").on("click", function(e) {
  		$(".categories1, .question2").fadeOut( function() {
  			$(".price, .question3").show().animate({left:"+15", opacity: 1},800);
  		});
  		e.stopPropogation();
	});

	$(".price").on('click', function(e) {
  		$(".price, .question3").fadeOut( function() {
  			$(".output, .question4").show().animate({left:"+15", opacity: 1}, 800);
  		});
  		e.stopPropogation();
	});

	$(".categorybox").on('click', function() {
    choice1=$(this).text()
  });

  $(".categorybox1").on('click', function() {
    choice2=$(this).text()
  });

  $(".categorybox2").on('click', function() {
    choice3=$(this).text()
    $.ajax({
          url: "/whattodo",
          type: "GET",
          dataType: "script",
          data: { choice1: choice1,
                  choice2: choice2,
                  choice3: choice3 }
        })
  });

});