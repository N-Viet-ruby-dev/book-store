var NotifyRoomListener = function (data) {
  var room = $("#room_" + data['room_id']);
  if ( room.length > 0 ) {
    room.replaceWith(data['room']);
  } else {
    $('#room-listener .inbox_chat').append(data['room']);
  }
}

$(document).ready(function (){
  var listener = $('#room-listener');
  if ( listener.length > 0 ) {
    App.global_listener = App.cable.subscriptions.create(
      {
        channel: "RoomListenerChannel",
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
