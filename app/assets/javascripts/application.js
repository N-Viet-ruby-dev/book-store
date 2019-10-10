//= require rails-ujs
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require activestorage
//= require cable
//= require gritter


var IconOnclick = function () {
  $('.clickable').click(function () {
    var parent = $(this).closest('li')
    parent.hide();
    parent.find('#delete_item_' + $(this).data('id')).val(true);
    jQuery.gritter.add({title: "The book store!", text: "Click update to finish!", time: 1000});
  });
}

var InputOnchange = function () {
  $('.num_input').on('change', function () {
    var max = parseInt($(this).attr('max'));
    var min = parseInt($(this).attr('min'));
    var quantity = parseInt($(this).val());
    var price = parseInt($(this).data('price'));
    var parent = $(this).closest('li');
    parent.find('.text_right.price').text('$' + quantity * price);
    if ( $(this).val() == max ) {
      jQuery.gritter.add({title: "The book store!", text: "Quantity can't higher", time: 1000});
    } else if ( $(this).val() == min ) {
      jQuery.gritter.add({title: "The book store!", text: "Quantity can't lower", time: 1000});
    };
  });
}

$(document).ready(function(){
  $('#addClass').click(function () {
    $('#qnimate').addClass('popup-box-on');
    $(this).css('display', 'none');
  });

  $('#removeClass').click(function () {
    $('#qnimate').removeClass('popup-box-on');
    $('#addClass').css('display', 'block');
  });

  IconOnclick();
  InputOnchange();
})
