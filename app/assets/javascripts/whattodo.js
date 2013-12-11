$(window).load(function() {
  	$(".topnav").animate({ opacity: 0 }, 0);
  	$(".topnav").delay(200).animate({top:"+=45", opacity: 1},1500);
    function start() {
      $(".buttons").hide()
      $(".categories1, .price, .output, .question2, .question3, .question4, .output1, #blackness").hide().animate({ opacity: 0 });
      $(".question, .bottom").hide().delay(100).fadeIn(800);
      $(".question, .bottom").hide().delay(100).fadeIn(800);
      $(".categories").animate({ opacity: 0 }, 0);
      $(".categories").animate({left:"+=20", opacity: 1},800);
      $(".categories").show();

  	$(".categories").on('click', function(e) {
     		$(".categories, .question").fadeOut( function() {
             	$(".categories1, .question2").show().animate({left:"+15", opacity: 1},800);
         	});
         	//e.stopPropogation();
     	});
  
    $(".back1").on('click', function(event){
      $(".categories1, .question2").fadeOut( function() {
              $(".categories, .question").show().animate({left:"+15", opacity: 1},800);
          });
    })
  	$(".categories1").on('click', function(e) {
    		$(".categories1, .question2").fadeOut( function() {
    			$(".price, .question3").show().animate({left:"+15", opacity: 1}, 800);
    		});
    		//e.stopPropogation();
  	});
    $(".back2").on('click', function(event){
      $(".price, .question3").fadeOut( function() {
              $(".categories1, .question2").show().animate({left:"+15", opacity: 1},800);
          });
    })
  	$(".categories1").on("click", function(e) {
    		$(".categories1, .question2").fadeOut( function() {
    			$(".price, .question3").show().animate({left:"+15", opacity: 1},500);
    		});
    		//e.stopPropogation();
  	});

  	$(".price").on('click', function(e) {
    		$(".price, .question3").fadeOut( function() {
          $("#blackness").show().animate({left:"+15", opacity: 1}, 1000).delay(500)
          var black=setTimeout(function() {
            $(".output, .question4, .output1").delay(500).show().animate({left:"+15", opacity: 1}, 1000);
          }, 1000)
          $("#blackness").fadeOut();
    			
    		});
    		//e.stopPropogation();
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
      var rank;
      var dist=null;
      var price=null;
      var rankbot=null;
      var distbot=null;
      var pricebot=null;
      var all=null;
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
      //toggle all results
      $("#all").on("click", function() {
        $(".buttons").toggle()
        
        if (all===null) {
        $.ajax({
            url: "/result/"+choice1+"/"+choice2+"/"+choice3,
            type: "GET",
            dataType: "script",
            data: { choice1: choice1,
                    choice2: choice2,
                    choice3: choice3,
                    button: "all" },
            complete: function(result){
              all=result.responseText.substr(20,(result.responseText.length)-15)
          }
        })
      } else {
        $(".alloutput").toggle()
      }

      $("#price").on("click", function(){
        $.ajax({
            url: "/result/"+choice1+"/"+choice2+"/"+choice3,
            type: "GET",
            dataType: "script",
            data: { choice1: choice1,
                    choice2: choice2,
                    choice3: choice3,
                    button: "all",
                    button2: "price" }
      })
    })
  })
  })
}
  start()
  $("#try").on("click", function() {
    var rank;
    var dist=null;
    var price=null;
    var rankbot=null;
    var distbot=null;
    var pricebot=null;
    var all=null;
    start()
  })
})



