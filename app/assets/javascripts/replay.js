$(document).ready(function() {
  $('#replay').click(function() {
    var request;

    request = $.ajax({
        url: "/api/spark/replay",
        data: {},
        type: 'GET',
        dataType: 'json'
    });
    request.success(function(data) {
          $('.conf-cont').css('z-index', '10000')
          $('.container-notifications').css('z-index', '10000')
          $('.conf-cont').fadeIn().next().delay(5000).fadeOut();
          $('.success-text').text("If music be the food of love, give me excess of it, so the appetite may sicken and so die.")

          $('.flag.note.success').slideDown();

          setTimeout(function() {
            $('.flag.note.success').slideUp();
            $('.conf-cont').fadeOut();
          }, 10000);
    });
    request.fail(function(error) {
        $('.note-text').text("Something didn't work. Stupid robot.")
          $('.flag.note.notice').slideDown();
            setTimeout(function() {
              $('.flag.note.notice').slideUp();
            }, 5000);
    });
  })
})