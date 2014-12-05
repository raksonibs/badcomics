var choice1,
    choice2,
    choice3,
    all,
    selection,
    catAfter = "Get Cultured",
    priceAfter = "Free";

$(document).ready(function() {
  $('.mainOptions').delay().fadeIn(500);
  $(".categories, .categories1, .price, .output, .question2, .question3, .question4, .output1, .bhome, .blackness, #foo")
    .animate({ opacity: 0}, 0);

   $('#select-app').click(function() {
    $(".mainOptions").delay().fadeOut(500);
    $(".question").delay().fadeIn(500);
    $(".categories, .bhome").delay().fadeIn().animate({left:"+20", opacity: 1}, 800);
   }) 



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
        .fadeIn()
        .animate({
          left:"+15",
          opacity: 1},800);
    });
  });

  $(".categorybox1").on('click', function(e) {
    choice2 = $(this).text().trim()
    $(".categories1, .question2, .b2feeling").fadeOut( function() {
      $(".price, .question3, .bk2category")
        .fadeIn()
        .animate({
          left: "+15",
          opacity: 1}, 800);
    });
  });

  $(".bk2category").on('click', function(event){
    $(".price, .question3, .bk2category, .back").fadeOut( function() {
      $(".categories1, .question2, .b2feeling")
        .fadeIn()
        .animate({
          left:"+15",
          opacity: 1},800);
    });
  });

  $(".price").on('click', function() {
    $(".price, .question3, .bk2category").fadeOut( function() {
    });
    $(".blackness")
        .delay(1500)
        .fadeIn('slow')
        .animate({left:"+45", opacity: 1}, 800)

      $("#foo")
        .delay(1500)
        .fadeIn('slow')
        .animate({left:"+900", opacity: 1}, 800)
        .css("display", "inline")
  });

  $(".categorybox2").on('click', function() {
    choice3 = $(this).text().trim()
    $('.alloutput').hide()
    $('.back').hide()
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
            $('.buttonAllDay, .btnTry, .right-results').fadeIn()
            $('.alloutput').fadeIn()
        }
    })
  });

  $(".redoSelection").bind().on('click', function() {
    $('.alloutput, .right-results').fadeOut('slow')
    $("#foo")
        .fadeIn()
        .animate({left:"+900", opacity: 1}, 800)
        .css("display", "inline")
        .delay(400);
    var funnyLoads=["Lining up meter sticks...", "Asking robots politely...", 
                    "Using cheat codes...", "Consulting magic 8-ball...", 
                    "Stacking monkeys...", "Loading catapult...", 
                    "Thinking harder than ever...", 
                    "Asking Oracle of Delphi...", 
                    "Synergizing a lot..."];
    $(".blackness").text(funnyLoads[Math.ceil(Math.random()*funnyLoads.length-1)])
    $('.blackness')
        .fadeIn('slow')
        .animate({left:"+45", opacity: 1}, 800)
        .delay(400)
    $('.back').hide()
    $.ajax({
        url: "/result/" + dateValues + "/" + catAfter + "/" + priceAfter,
        type: "GET",
        dataType: "script",
        data: { choice1: dateValues,
                choice2: catAfter,
                choice3: priceAfter },
        complete: function(data) {
            $("#foo").fadeOut("slow")
            $(".blackness").fadeOut("slow")
            $('.alloutput, .right-results').fadeIn('slow')
            $('.buttonAllDay, .btnTry, .right-results-change').fadeIn()
        }
    })
  });
  
})

$(document).ready(function (){
    var strings = ['#selectCat', '#selectPrice']
    for (var i = 0; i < strings.length; i++) {
      string = strings[i]
      $(string).wrap('<div class="select_wrapper"></div>')
      $(string).parent().prepend('<span>'+ $(this).find(':selected').text() +'</span>');
      $(string).parent().children('span').width($(string).width('100%'));   
      $(string).css('display', 'none');                 
      $(string).parent().append('<ul class="select_inner"></ul>');
      $(string).children().each(function(){
        var opttext = $(this).text();
        var optval = $(this).val();
        $(string).parent().children('.select_inner').append('<li id="' + optval + '">' + opttext + '</li>');
      });
       
       
       
      $(string).parent().find('li').on('click', function (){
        var cur = $(this).attr('id');
        $(string).parent().children('span').text($(this).text());
        $(string).children().removeAttr('selected');
        $(string).children('[value="'+cur+'"]').attr('selected','selected');                    
        console.log($(string).children('[value="'+cur+'"]').text());
      });
      $(string).parent().on('click', function (){
        $(this).find('ul').slideToggle('fast');
      });
    }
});

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