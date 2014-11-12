// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require underscore
//= require gmaps/google
//= require spin
//= require_tree .

var dateValues;

$(function() {
  $.datepicker.setDefaults(
    $.extend($.datepicker.regional[''])
  );

  $('#datepicker').datepicker({
    onSelect: function(dateText, obj) {
      $(this).css('background-color','');
      // month/day/year
      dateValues = dateText
      $(".categories, .question, .bhome").fadeOut( function() {
        $(".categories1, .question2, .b2feeling")
          .show()
          .animate({
            left:"+15",
            opacity: 1},800);
    });
    }
  });
  $('#datepicker').datepicker();
});