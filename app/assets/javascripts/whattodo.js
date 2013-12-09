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

	$(".categories1, .price, .output, .question2, .question3, .question4, .output1").hide().animate({ opacity: 0 });
	
	$(".categories").one('click', function(e) {
   		$(".categories, .question").fadeOut( function() {
           	$(".categories1, .question2").show().animate({left:"+15", opacity: 1},800);
       	});
       	//e.stopPropogation();
   	});

	$(".categories1").one('click', function(e) {
  		$(".categories1, .question2").fadeOut( function() {
  			$(".price, .question3").show().animate({left:"+15", opacity: 1}, 800);
  		});
  		//e.stopPropogation();
	});

	$(".categories1").one("click", function(e) {
  		$(".categories1, .question2").fadeOut( function() {
  			$(".price, .question3").show().animate({left:"+15", opacity: 1},800);
  		});
  		//e.stopPropogation();
	});

	$(".price").one('click', function(e) {
  		$(".price, .question3").fadeOut( function() {
  			$(".output, .question4, .output1").show().animate({left:"+15", opacity: 1}, 800);
  		});
  		//e.stopPropogation();
	});

	$(".categorybox").one('click', function() {
    choice1=$(this).text()
  });

  $(".categorybox1").one('click', function() {
    choice2=$(this).text()
  });
//result/happy/art/20
  $(".categorybox2").one('click', function() {
    choice3=$(this).text()
    var rank;
    var dist=null;
    var price=null;
    var rankbot=null;
    var distbot=null;
    var pricebot=null;
    $.ajax({
          url: "/result/"+choice1+"/"+choice2+"/"+choice3,
          type: "GET",
          dataType: "script",
          data: { choice1: choice1,
                  choice2: choice2,
                  choice3: choice3 },
          complete: function(result){
            rank=result.responseText.substr(20,(result.responseText.length)-3)
            
          }
          
        })
    
    $("#disttop").on("click", function() {
      if (dist===null) {
      $.ajax({
          url: "/result/"+choice1+"/"+choice2+"/"+choice3,
          type: "GET",
          dataType: "script",
          data: { choice1: choice1,
                  choice2: choice2,
                  choice3: choice3,
                  button: "dist" },
          complete: function(result){
            dist=result.responseText.substr(20,(result.responseText.length)-15)

          
        }
      })
    } else {
      $(".output").html(dist)
    }
  })
    $("#distbot").on("click", function() {
      if (distbot===null) {
      $.ajax({
          url: "/result/"+choice1+"/"+choice2+"/"+choice3,
          type: "GET",
          dataType: "script",
          data: { choice1: choice1,
                  choice2: choice2,
                  choice3: choice3,
                  button: "distbot" },
          complete: function(result){
            distbot=result.responseText.substr(20,(result.responseText.length)-15)

          
        }
      })
    } else {
      $(".output").html(distbot)
    }
    
    })
    $("#rankbot").on("click", function() {
      if (rank===null) {
      $.ajax({
          url: "/result/"+choice1+"/"+choice2+"/"+choice3,
          type: "GET",
          dataType: "script",
          data: { choice1: choice1,
                  choice2: choice2,
                  choice3: choice3,
                  button: "rankbot" },
          complete: function(result){
            rankbot=result.responseText.substr(20,(result.responseText.length)-15)

          
        }
      })
    } else {
      $(".output").html(rankbot)
    }
    
    })
    $("#ranktop").on("click", function() {
      $(".output").html(rank)
    })
    
    $("#price1top").on("click", function() {
      if (price===null) {
      $.ajax({
          url: "/result/"+choice1+"/"+choice2+"/"+choice3,
          type: "GET",
          dataType: "script",
          data: { choice1: choice1,
                  choice2: choice2,
                  choice3: choice3,
                  button: "price" },
           complete: function(result){
            price=result.responseText.substr(20,(result.responseText.length)-10)
          }
        })
    }else {
      $(".output").html(price)
    }
    })

     $("#price1bot").on("click", function() {
      if (pricebot===null) {
      
      $.ajax({
          url: "/result/"+choice1+"/"+choice2+"/"+choice3,
          type: "GET",
          dataType: "script",
          data: { choice1: choice1,
                  choice2: choice2,
                  choice3: choice3,
                  button: "pricebot" },
           complete: function(result){
            pricebot=result.responseText.substr(20,(result.responseText.length)-10)
          }
        })
    }else {
      $(".output").html(pricebot)
    }
    })
  });

});

