var PrependNotification = function (data) {
  var notify_bell = $('#notify_bell');
  var notification_list = $('#notification_list');
  notify_bell.addClass('bell');
  notification_list.prepend(data.content);
}

var NotificationChannel = function () {
  var notify_bell = $('#notify_bell');

  if ( notify_bell.length > 0 ) {
    App.notification = App.cable.subscriptions.create(
    {
      channel:'NotificationChannel',
      notifier_id: notify_bell.data('user-id')
    },
    {
      connected() {},
      disconnected() {},
      received(data) {
        PrependNotification(data);
      }
    }
    );
  }
}

$(document).ready(function () {
  NotificationChannel();
})

