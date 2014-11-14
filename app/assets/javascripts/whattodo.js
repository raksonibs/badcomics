var choice1,
    choice2,
    choice3,
    all,
    selection;

$(document).ready(function() {

  $(".categories, .categories1, .price, .output, .question2, .question3, .question4, .output1, .bhome, .blackness, #foo")
    .animate({ opacity: 0}, 0);

  $(".question").delay().fadeIn(500);

  $(".categories, .bhome").delay().fadeIn().animate({left:"+20", opacity: 1}, 800);

  $(".topnav")
    .animate({
      opacity: 0 }, 0)
    .delay(200)
    .animate({
      top:"+=45",
      opacity: 1},1500);

  $(".b2feeling").on('click', function(event){
    $(".categories1, .question2, .b2feeling").fadeOut( function() {
      $(".categories, .question, .bhome")
        .show()
        .animate({
          left:"+15",
          opacity: 1},800);
    });
  });

  $(".categorybox1").on('click', function(e) {
    choice2 = $(this).text().trim()
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

  $(".categorybox2").on('click', function() {
    choice3 = $(this).text().trim()
    console.log("/result/" + dateValues + "/" + choice2 + "/" + choice3)
    $.ajax({
        url: "/result/" + dateValues + "/" + choice2 + "/" + choice3,
        type: "GET",
        dataType: "script",
        data: { choice1: dateValues,
                choice2: choice2,
                choice3: choice3 },
        complete: function(data) {
            $('.buttonAllDay, .btnTry, .right-results-change').show()
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
})

$(document).on('click', '.buttonAllDay', function() {  
  $('.allDayResults').toggle()
})