//= require jquery
//= require jquery_ujs
//= require jquery-ui/sortable
//= require s3_direct_upload
//= require foundation
//= require turbolinks
//= require_tree .


// var re = /http:\/\/www\.badcomics\.ca/;
// var redirectCount = 0;
// // var re = /http:\/\//;
// if (re.exec(window.location.href) !== "" && redirectCount === 0) {
//   // CORS not working, hacky approach NTD: Fix this.
//   console.log('matched')
//   window.location.replace('http://badcomics.ca');
//   redirectCount += 1;
// }

$(function(){ $(document).foundation(); });

(function($) {    
  if ($.fn.style) {
    return;
  }

  // Escape regex chars with \
  var escape = function(text) {
    return text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&");
  };

  // For those who need them (< IE 9), add support for CSS functions
  var isStyleFuncSupported = !!CSSStyleDeclaration.prototype.getPropertyValue;
  if (!isStyleFuncSupported) {
    CSSStyleDeclaration.prototype.getPropertyValue = function(a) {
      return this.getAttribute(a);
    };
    CSSStyleDeclaration.prototype.setProperty = function(styleName, value, priority) {
      this.setAttribute(styleName, value);
      var priority = typeof priority != 'undefined' ? priority : '';
      if (priority != '') {
        // Add priority manually
        var rule = new RegExp(escape(styleName) + '\\s*:\\s*' + escape(value) +
            '(\\s*;)?', 'gmi');
        this.cssText =
            this.cssText.replace(rule, styleName + ': ' + value + ' !' + priority + ';');
      }
    };
    CSSStyleDeclaration.prototype.removeProperty = function(a) {
      return this.removeAttribute(a);
    };
    CSSStyleDeclaration.prototype.getPropertyPriority = function(styleName) {
      var rule = new RegExp(escape(styleName) + '\\s*:\\s*[^\\s]*\\s*!important(\\s*;)?',
          'gmi');
      return rule.test(this.cssText) ? 'important' : '';
    }
  }

  // The style function
  $.fn.style = function(styleName, value, priority) {
    // DOM node
    var node = this.get(0);
    // Ensure we have a DOM node
    if (typeof node == 'undefined') {
      return this;
    }
    // CSSStyleDeclaration
    var style = this.get(0).style;
    // Getter/Setter
    if (typeof styleName != 'undefined') {
      if (typeof value != 'undefined') {
        // Set style property
        priority = typeof priority != 'undefined' ? priority : '';
        style.setProperty(styleName, value, priority);
        return this;
      } else {
        // Get style property
        return style.getPropertyValue(styleName);
      }
    } else {
      // Get CSSStyleDeclaration
      return style;
    }
  };
})(jQuery);

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