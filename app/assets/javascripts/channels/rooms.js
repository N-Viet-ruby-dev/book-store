var ScrollBot = function (selector){
  selector.scrollTop(selector[0].scrollHeight);
};

var AppendMessageHtml = function (data, messages){
  if ( data['user_id'] == messages.data('user-id') ) {
    html = "<div class='outgoing_msg'><div class='sent_msg'><p>" +
      data['message'] + "</p><span class='time_date'>" +
      data["hour_minute"] + " | " + data['month_day'] +
      "</span></div></div>";
    messages.append(html);
  } else {
    html = "<div class='incoming_msg'><div class='incoming_msg_img'>" +
      "<img src='https://ptetutorials.com/images/user-profile.png'></div>" +
      "<div class='received_msg'><div class='received_withd_msg'><p>" +
      data['message'] + "</p><span class='time_date'>" +
      data['hour_minute'] + " | " + data['month_day'] +
      "</span></div></div></div>";
    messages.append(html);
  }
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
        AppendMessageHtml(data, messages);
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
