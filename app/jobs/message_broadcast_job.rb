# frozen_string_literal: true

class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast "rooms_#{message.room.id}_channel",
                                 msg_user_id: message.user_id,
                                 incoming_msg: incoming_msg_renderer(message),
                                 outgoing_msg: outgoing_msg_renderer(message)
  end

  private

  def outgoing_msg_renderer(message)
    RoomMessagesController.render partial: "room_messages/incoming_msg",
                                  locals: { room_message: message }
  end

  def incoming_msg_renderer(message)
    RoomMessagesController.render partial: "room_messages/outgoing_msg",
                                  locals: { room_message: message }
  end
end
