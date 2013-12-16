var choice1,
    choice2,
    choice3,
    all,
    selection;

$(function() {

	$(".topnav").animate({ opacity: 0 }, 0).delay(200).animate({top:"+=45", opacity: 1},1500);

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
  });

  $(".categories1").on('click', function(e) {
    $(".categories1, .question2").fadeOut( function() {
      $(".price, .question3")
        .show()
        .animate({
          left: "+15",
          opacity: 1}, 800);
    });
    //e.stopPropogation();
  });

  $(".back2").on('click', function(event){
    $(".price, .question3").fadeOut( function() {
      $(".categories1, .question2").show().animate({left:"+15", opacity: 1},800);
    });
  });

  $(".price").on('click', function(e) {
    $(".price, .question3").fadeOut( function() {
      $("#blackness")
        .show()
        .animate({left:"+15", opacity: 1}, 800)
        .delay(400);

      var black = setTimeout(function() {
        $(".output, .question4, .output1")
          .delay(500)
          .show()
          .animate({left:"+15", opacity: 1}, 1000);
      }, 1000);

      $("#blackness").fadeOut();
    });
    //e.stopPropogation();
  });

  $(".categorybox").on('click', function() {
    choice1 = $(this).text();
  });

  $(".categorybox1").on('click', function() {
    choice2 = $(this).text();
  });

  $(".categorybox2").on('click', function() {
    choice3 = $(this).text();

    $.ajax({
        url: "/result/" + choice1 + "/" + choice2 + "/" + choice3,
        type: "GET",
        dataType: "script",
        data: { choice1: choice1,
                choice2: choice2,
                choice3: choice3 },
        complete: function(data) {

            function initialize()
            {
                var arrcount=0
                var arr=$(".hidden").text().split(",")
                for (var i=0; i<=2; i++) {
                  console.log(arr[arrcount])
    
                  if (i === 0) {
                    arrcount=0
                  } else if (i === 1) {
                    arrcount = 2
                  } else if (i === 2) {
                    arrcount = 4
                  }
                  var mapProp = {
                  center:new google.maps.LatLng(parseFloat(arr[arrcount]),parseFloat(arr[arrcount+1])),
                  zoom:15,
                  mapTypeId:google.maps.MapTypeId.ROADMAP
                  };
                  
                  
                  var myLatlng= (parseFloat(arr[arrcount]),parseFloat(arr[arrcount+1]))
                  var map=new google.maps.Map($(".map")[i]
                    ,mapProp);
                  google.maps.event.addListenerOnce(map, 'idle', function() {
                     var center = map.getCenter();
                     google.maps.event.trigger(map, "resize");
                     map.setCenter(center); 
                  });
                  var marker = new google.maps.Marker({
                    position: mapProp.center,
                    map: map,
                  })

            }
          }

            initialize()
            
        }
    })
  });

  $("#all").on("click", function() {
    $(".buttons").toggle();

    if (all === undefined) {
      $.ajax({
          url: "/result/" + choice1 + "/" + choice2 + "/" + choice3,
          type: "GET",
          dataType: "script",
          data: { choice1: choice1,
                  choice2: choice2,
                  choice3: choice3,
                  button: "all" },
          complete: function(data) {
            all=data.responseText;
          }
      });
    } else {
      $(".alloutput").toggle();
      $(".buttons").toggle();
    }

    // $("#down").on("click", function(){
    //   $.ajax({
    //     url: "/result/" + choice1 + "/" + choice2 + "/" + choice3,
    //     type: "GET",
    //     dataType: "script",
    //     data: { choice1: choice1,
    //             choice2: choice2,
    //             choice3: choice3,
    //             button: "all",
    //             button2: "rank",
    //             button3: "down" }
    //   })
    // })

    $("#up").on("click", function(){
      $.ajax({
        url: "/result/" + choice1 + "/" + choice2 + "/" + choice3,
        type: "GET",
        dataType: "script",
        data: { choice1: choice1,
                choice2: choice2,
                choice3: choice3,
                button: "all",
                button2: "rank" }
      })
    })
    

  });

  $('.sort-order').on('click', function() {
    var self = $(this);
    console.log(self.data('sort-order'))
    $.ajax({
        url: "/result/" + choice1 + "/" + choice2 + "/" + choice3,
        type: "GET",
        dataType: "script",
        data: { choice1: choice1,
                choice2: choice2,
                choice3: choice3,
                button: "all",
                button2: self.data('sort-order') }
      });
    });


    $("#down").on("click", function(){
      $.ajax({
        url: "/result/" + choice1 + "/" + choice2 + "/" + choice3,
        type: "GET",
        dataType: "script",
        data: { choice1: choice1,
                choice2: choice2,
                choice3: choice3,
                button: "all",
                button2: self.data('sort-order'),
                button3: "down" }
      })
    })

    // $("#up").on("click", function(){
    //   $.ajax({
    //     url: "/result/" + choice1 + "/" + choice2 + "/" + choice3,
    //     type: "GET",
    //     dataType: "script",
    //     data: { choice1: choice1,
    //             choice2: choice2,
    //             choice3: choice3,
    //             button: "all",
    //             button2: self.data('sort-order') }
    //   })
    // })

  

  $("#try").on("click", function() {
      $(".question4, .alloutput, .buttons, .output").hide();
      $('html, body').animate({scrollTop: '0px'}, 900);
      all=undefined
      start();
  });

  start();
});

function start() {
  $(".categories, .categories1, .price, .output, .question2, .question3, .question4, .output1, #blackness").animate({ opacity: 0 }, 0);
  $(".question, .bottom").fadeIn(500);
  $(".categories").fadeIn().animate({left:"+20", opacity: 1}, 800);
}
