var ScrollBot = function (selector){
  selector.scrollTop(selector[0].scrollHeight);
};

var CreateRoomChanel = function () {
  var messages = $('#messages');
  ScrollBot(messages);
  App.global_chat = App.cable.subscriptions.create(
    {
      channel: "RoomsChannel",
      room_id: messages.data('room-id')
    },
    {
      connected() {},
      disconnected() {},
      received(data) {
          messages.append(data['message']);
          ScrollBot(messages);
      },
      send_message(message, room_id) {
        return this.perform('send_message', {message, room_id});
      }
    }
  );

  $('#new_room_message').submit(function(e) {
    e.preventDefault();
    var textarea = $(this).find('#room_message_message');
    if ($.trim(textarea.val()).length > 1) {
      App.global_chat.send_message(textarea.val(), messages.data('room-id'));
      ScrollBot(messages);
      textarea.val('');
    }
    return false;
  });
};
