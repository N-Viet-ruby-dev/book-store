# frozen_string_literal: true

class RoomsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "rooms_#{params['room_id']}_channel"
  end

  def unsubscribed; end

  def send_message(data)
    current_user.room_messages.create!(message: data["message"], room_id: data["room_id"])
  end
end
