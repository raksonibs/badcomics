//= require jquery
//= require jquery_ujs
//= require jquery-ui/sortable
//= require s3_direct_upload
//= require foundation
//= require turbolinks
//= require_tree .


var re = /http:\/\/www\./;
// var re = /http:\/\//;
if (re.exec(window.location.href) !== "") {
  // CORS not working, hacky approach NTD: Fix this.
  window.location.replace('http://badcomics.ca');
}

$(function(){ $(document).foundation(); });

Array.prototype.equals = function (array) {
    // if the other array is a falsy value, return
    if (!array)
        return false;

    // compare lengths - can save a lot of time 
    if (this.length != array.length)
        return false;

    for (var i = 0, l=this.length; i < l; i++) {
        // Check if we have nested arrays
        if (this[i] instanceof Array && array[i] instanceof Array) {
            // recurse into the nested arrays
            if (!this[i].equals(array[i]))
                return false;       
        }           
        else if (this[i] != array[i]) { 
            // Warning - two different object instances will never be equal: {x:20} != {x:20}
            return false;   
        }           
    }       
    return true;
}   

$(function() {
  $('#s3_uploader').S3Uploader(
    { 
      remove_completed_progress_bar: false,
      progress_bar_target: $('#uploads_container')
    }
  );
  $('#s3_uploader').bind('s3_upload_failed', function(e, content) {
    return alert(content.filename + ' failed to upload');
  });
});

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