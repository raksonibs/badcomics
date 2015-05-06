//= require jquery
//= require jquery_ujs
//= require jquery-ui/sortable
//= require foundation
//= require turbolinks
//= require_tree .

$(function(){ $(document).foundation(); });

(function($) {
  $('#sortable').sortable({
    stop: function(e, ui) {
      var arrIndexes = ($.map($(this).find('li'), function(el) {
        return el.id + ' = ' + $(el).index();
      }));

      console.log('ajax?')

      $.ajax({
        url: "/save_order",
        type: "GET",
        dataType: "json",
        data: {images: arrIndexes },
        complete: function(data) {
          $('.note-text').text("Order saved. I think.")
    $('.flag.note.notice').slideDown();
      setTimeout(function() {
        $('.flag.note.notice').slideUp();
      }, 5000);
        }
      })
    }
  });
})(jQuery);

// $('#sortable').sortable({
  //   start: function(event, ui) {
  //     var start_pos = ui.item.index();
  //     ui.item.data('start_pos', start_pos);
  //   },
  //   change: function(event, ui) {
  //     var start_pos = ui.item.data('start_pos');
  //     var index = ui.placeholder.index();
  //     if (start_pos < index) {
  //       $('#sortable li:nth-child(' + index + ')').addClass('highlights');
  //     } else {
  //       $('#sortable li:eq(' + (index + 1) + ')').addClass('highlights');
  //     }
  //     console.log(index + " is changing")
  //   },
  //   update: function(event, ui) {
  //     $('#sortable li').removeClass('highlights');
  //     var index = ui.placeholder.index();
  //     console.log(index + " changed to")
  //   }
  // });