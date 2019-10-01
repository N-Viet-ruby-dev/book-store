$(document).ready(function(){
  App.appearance = App.cable.subscriptions.create({
    channel:'AppearanceChannel'
  });
})
