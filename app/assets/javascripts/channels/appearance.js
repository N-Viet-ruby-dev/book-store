var CreateApperanceChanel = function () {
  App.appearance = App.cable.subscriptions.create({
    channel:'AppearanceChannel'
  });
}

$(document).ready(function () {
  CreateApperanceChanel();
})

