var NotifyRoomListener = function (data) {
  var room = $('.chat_list#item_' + data['room_id']);
  if ( room.length > 0 ) {
    if ( room[0].classList.contains('active') ) {
      room.replaceWith(data['room']);
      $('.chat_list#item_' + data['room_id']).addClass('active');
    } else {
      room.replaceWith(data['room']);
    };
  } else {
    $('#room-listener .inbox_chat').append(data['room']);
  }
}

$(document).ready(function (){
  var listener = $('#room-listener');
  if ( listener.length > 0 ) {
    App.global_listener = App.cable.subscriptions.create(
      {
        channel: 'RoomListenerChannel',
        listener_id: listener.data('listener-id')
      },
      {
        connected() {},
        disconnected() {},
        received(data) {
          NotifyRoomListener(data);
        }
      }
    );
  }
})
