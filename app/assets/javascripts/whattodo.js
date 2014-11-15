var choice1,
    choice2,
    choice3,
    all,
    selection,
    catAfter = "Get Cultured",
    priceAfter = "Free";

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
    });
  });

  $(".categorybox2").on('click', function() {
    choice3 = $(this).text().trim()
    console.log("/result/" + dateValues + "/" + choice2 + "/" + choice3)
    $('.alloutput').hide()
    $.ajax({
        url: "/result/" + dateValues + "/" + choice2 + "/" + choice3,
        type: "GET",
        dataType: "script",
        data: { choice1: dateValues,
                choice2: choice2,
                choice3: choice3 },
        complete: function(data) {
            $("#foo").hide()
            $(".blackness").hide();
            $('.buttonAllDay, .btnTry, .right-results').show()
            $('.alloutput').fadeIn()
        }
    })
  });

  $(".redoSelection").bind().on('click', function() {
    $('.alloutput').fadeOut('slow')
    $("#foo")
        .show()
        .animate({left:"+900", opacity: 1}, 800)
        .css("display", "inline")
        .delay(400);
    console.log("/result/" + dateValues + "/" + catAfter + "/" + priceAfter)
    $.ajax({
        url: "/result/" + dateValues + "/" + catAfter + "/" + priceAfter,
        type: "GET",
        dataType: "script",
        data: { choice1: dateValues,
                choice2: catAfter,
                choice3: priceAfter },
        complete: function(data) {
            $("#foo").fadeOut("slow")
            $('.alloutput').fadeIn('slow')
            $('.buttonAllDay, .btnTry, .right-results-change').show()
        }
    })
  });

  
})

$(document).on('click', '.buttonAllDay', function() {  
  $('.allDayResults').toggle()
})

$(document).on('change', '.select', function() {
  $this = $(this)
  selectedOpt = $this.find(':selected').text()
  if ($this.attr('name') == "selectCat") {
    catAfter = selectedOpt.trim()
  } else {
    priceAfter = selectedOpt.trim()
  } 
})