# frozen_string_literal: true

class RoomsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "rooms_#{params['room_id']}_channel"
  end

  def unsubscribed; end

  def send_message(data)
    current_user.room_messages.create!(message: data["message"], room_id: data["room_id"])
    room = Room.find(data["room_id"])
    room.update_on_send_message(current_user)
    room.assign_to_admin unless room.assignee_id
  end
end
