$(document).ready(function(){
  var appearance_flag = $('body').data('flag')
  if ( appearance_flag == 1 ) {
    App.appearance = App.cable.subscriptions.create({
      channel:'AppearanceChannel'
    });
  }
})
