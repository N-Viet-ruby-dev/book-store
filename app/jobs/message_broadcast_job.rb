# frozen_string_literal: true

class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(room_message)
    ActionCable.server.broadcast "rooms_#{room_message.room.id}_channel",
      message: room_message.message,
      hour_minute: room_message.created_at.strftime("%H:%M"),
      month_day: room_message.created_at.strftime("%b %d"),
      user_id: room_message.user_id
  end
end
