var CreateApperanceChanel = function () {
  App.appearance = App.cable.subscriptions.create({
    channel:'AppearanceChannel'
  });
}

$(document).ready(function () {
  if( $('body.admin').length > 0 ) {
    CreateApperanceChanel();
  };
})

