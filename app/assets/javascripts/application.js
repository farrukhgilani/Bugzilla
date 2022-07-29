// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .


// Tried this code for alert fade
// $(".alert").delay(4000).slideUp(200, function() {
//   $(this).alert('close');
// });

//import Rails from 'rails-ujs'
//Rails.start()

$(document).ready(function(){
  $('.destroy').on('click', function() {
    if (confirm("Are you sure to delete?")){
      $.ajax({
        url: '/projects/' + this.parentElement.id,
        type: 'DELETE',
        success: function(r){

        }
      });
    }
  });
});
