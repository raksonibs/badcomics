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
<<<<<<< HEAD
// 
//= require jquery
//= require_tree .
$(document).ready(function() {
  console.log('ready')
  $('.button').click(function() {
    console.log('shooting event')
    $.get("/api/v1/create_token", function(data) {
      console.log('data sent')
      $('.key-holder').text("Your access token: " + data.access_token)
    })
  })
})
=======
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require turbolinks
//= require_tree .

$(function(){ $(document).foundation(); });
>>>>>>> 6721de769c2e5cfebde11d8b6c385461dda1287d
