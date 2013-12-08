
$(window).load(function() {
  
	$(".topnav").animate({ opacity: 0 }, 0);
	$(".topnav").delay(200).animate({top:"+=45", opacity: 1},1500);

	$(".question, .bottom").hide().delay(100).fadeIn(800);

	$(".categories").animate({ opacity: 0 }, 0);
	$(".categories").animate({left:"+=20", opacity: 1},800);

	$(".categories1, .price, .output, .question2, .question3, .question4").hide().animate({ opacity: 0 });
	
	$(".categories").one('click', function(e) {
   		$(".categories, .question").fadeOut( function() {
           	$(".categories1, .question2").show().animate({left:"+15", opacity: 1},800);
       	});
   	});

	$(".categories1").on('click', function(e) {
  		$(".categories1, .question2").fadeOut( function() {
  			$(".price, .question3").show().animate({left:"+15", opacity: 1}, 800);
  		});
	});

	$(".categories1").on("click", function(e) {
  		$(".categories1, .question2").fadeOut( function() {
  			$(".price, .question3").show().animate({left:"+15", opacity: 1},800);
  		});
	});

	$(".categorybox").on('click', function() {
    choice1=$(this).text()
  });

  $(".categorybox1").on('click', function() {
    choice2=$(this).text()
  });
//result/happy/art/20
  $(".categorybox2").on('click', function() {
    choice3=$(this).text()
    $.ajax({
          url: "/result/"+choice1+"/"+choice2+"/"+choice3,
          type: "GET",
          dataType: "script",
          data: { choice1: choice1,
                  choice2: choice2,
                  choice3: choice3 },
          success: function(result){
                  console.log(result)
                  $(".output").html(result)
                 $(".price, .question3").fadeOut( function() {
                $(".output, .question4").show().animate({left:"+15", opacity: 1}, 800);
                });
          }  
        })
    return false;
  });

});