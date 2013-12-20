var choice1,
    choice2,
    choice3,
    all,
    selection;

var upsanddowns=[".ourrankdir", ".pricedir", ".distdir", ".timedir"]


$(function() {

  $(".topnav")
    .animate({
      opacity: 0 }, 0)
    .delay(200)
    .animate({
      top:"+=45",
      opacity: 1},1500);

  $(".categories").on('click', function() {
    $(".categories, .question, .bhome").fadeOut( function() {
        $(".categories1, .question2, .b2feeling")
          .show()
          .animate({
            left:"+15",
            opacity: 1},800);
    });
  });

  $(".b2feeling").on('click', function(event){
    $(".categories1, .question2, .b2feeling").fadeOut( function() {
      $(".categories, .question, .bhome")
        .show()
        .animate({
          left:"+15",
          opacity: 1},800);
    });
  });

  $(".categories1").on('click', function(e) {
    $(".categories1, .question2, .b2feeling").fadeOut( function() {
      $(".price, .question3, .bk2category")
        .show()
        .animate({
          left: "+15",
          opacity: 1}, 800);
    });
  });

  $(".bk2category").on('click', function(event){
    $(".price, .question3, .bk2category").fadeOut( function() {
      $(".categories1, .question2, .b2feeling")
        .show()
        .animate({
          left:"+15",
          opacity: 1},800);
    });
  });

  $(".price").on('click', function() {
    $(".price, .question3, .bk2category").fadeOut( function() {
      $(".blackness")
        .show()
        .animate({left:"+45", opacity: 1}, 800)
        .delay(400);

      $("#foo")
        .show()
        .animate({left:"+900", opacity: 1}, 800)
        .css("display", "inline")
        .delay(400);
      var black = setTimeout(function() {
        $(".output, .question4, .output1")
          .delay(500)
          .show()
          .animate({left:"+15", opacity: 1}, 1000);
      }, 1000);

      $(".blackness").fadeOut();
      $("#foo").fadeOut("slow")
    });
  });

  $(".categorybox").on('click', function() {
    choice1 = $($(this).children()[1]).text()

  });

  $(".categorybox1").on('click', function() {
    choice2 = $($(this).children()[1]).text()

  });

  $(".categorybox2").on('click', function() {
    choice3 = $($(this).children()[1]).text()

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
                  if (i === 0) {
                    arrcount=0
                  } else if (i === 1) {
                    arrcount = 2
                  } else if (i === 2) {
                    arrcount = 4
                  }
                  console.log(arr[arrcount].replace(/\s+/g, " "))
                  console.log(arr[arrcount].replace(/\s+/g, " ") !== " " )
                  if (arr[arrcount].replace(/\s+/g, " ") !== " " ) {
                    var mapProp = {
                    center:new google.maps.LatLng(parseFloat(arr[arrcount]),parseFloat(arr[arrcount+1])),
                    zoom:15,
                    mapTypeId:google.maps.MapTypeId.ROADMAP
                    };

                    var myLatlng= (parseFloat(arr[arrcount]),parseFloat(arr[arrcount+1]))
                    var map=new google.maps.Map($(".map")[i]
                      ,mapProp);

                    var marker = new google.maps.Marker({
                      position: mapProp.center,
                      map: map,
                    });

                    google.maps.event.addListenerOnce(map, 'idle', function() {
                       //var center = map.getCenter();

                       //map.setCenter(center);
                       google.maps.event.trigger(map, "resize");
                    });
                  }
            }
          }
          setTimeout(function() {
            initialize()
          }, 3000)

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
            $(".ourrankdir").css("visibility", "visible")
          }
      });
      $(".alloutput").css("display","block");
    } else {
      $(".alloutput").toggle();
      $(".buttons").toggle();
    }

  });

  $('.sort-order').on('click', function() {
    var self = $(this);


    $.ajax({
        url: "/result/" + choice1 + "/" + choice2 + "/" + choice3,
        type: "GET",
        dataType: "script",
        data: { choice1: choice1,
                choice2: choice2,
                choice3: choice3,
                button: "all",
                button2: self.data('sort-order') },
        complete: function() {
            var value= "."+self.data('sort-order')+"dir"
            for (var i=0; i<upsanddowns.length; i++) {
              if (value === upsanddowns[i]) {
                $(value).css("visibility", "visible")
              } else {
                $(upsanddowns[i]).css("visibility", "hidden")
              }
            }
          }
      });
    });


    $(".down").on("click", function(){
      selection= ($(this).attr("class").split(/\s/)[0].replace(/dir/,""))

      $.ajax({
          url: "/result/" + choice1 + "/" + choice2 + "/" + choice3,
          type: "GET",
          dataType: "script",
          data: { choice1: choice1,
                  choice2: choice2,
                  choice3: choice3,
                  button: "all",
                  button2: selection,
                  button3: "down"}

      })
    })

    $(".up").on("click", function(){
      selection= ($(this).attr("class").split(/\s/)[0].replace(/dir/,""))
      $.ajax({
          url: "/result/" + choice1 + "/" + choice2 + "/" + choice3,
          type: "GET",
          dataType: "script",
          data: { choice1: choice1,
                  choice2: choice2,
                  choice3: choice3,
                  button: "all",
                  button2: selection,
                  button3: "up"
                  }

      })
    })

  $("#try").on("click", function() {
      $(".question4, .alloutput, .buttons, .output, .b2feeling, .bk2category, .output1").hide();
      $('html, body').animate({scrollTop: '0px'}, 900);
      all=undefined
      start();
  });

  start();
});

function start() {
  $(".categories, .categories1, .price, .output, .question2, .question3, .question4, .output1, .bhome, .blackness, #foo")
    .animate({ opacity: 0}, 0);

  $(".question").delay().fadeIn(500);

  $(".categories, .bhome").delay().fadeIn().animate({left:"+20", opacity: 1}, 800);

};