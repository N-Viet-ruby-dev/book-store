class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform room_message
    ActionCable.server.broadcast "rooms_#{room_message.room.id}_channel", message: render_message(room_message)
  end

  private

  def render_message(room_message)
    RoomMessagesController.render partial: "room_messages/room_message", locals: { room_message: room_message }
  end
end
