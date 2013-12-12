var choice1,
    choice2,
    choice3,
    all;

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
                choice3: choice3 }
    });
  });

  $("#all").on("click", function() {
    $(".buttons").toggle();

    if (all === undefined) {
      console.log("hello")
      $.ajax({
          url: "/result/" + choice1 + "/" + choice2 + "/" + choice3,
          type: "GET",
          dataType: "script",
          data: { choice1: choice1,
                  choice2: choice2,
                  choice3: choice3,
                  button: "all" },
          complete: function(data) {
            all=data.responseText
          }
      });
    } else {
      $(".alloutput").toggle();
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
                button2: self.data('sort-order') }
    });
  });

  $("#try").on("click", function() {
      $(".question4, .alloutput, .output, .buttons").hide();
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
