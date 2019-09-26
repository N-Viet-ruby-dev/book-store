//= require rails-ujs
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require activestorage
//= require cable

$(document).ready(function(){
  $("#addClass").click(function () {
    $('#qnimate').addClass('popup-box-on');
    $(this).css("display", "none");
  });
  $("#removeClass").click(function () {
    $('#qnimate').removeClass('popup-box-on');
    $("#addClass").css("display", "block");
  });
})
