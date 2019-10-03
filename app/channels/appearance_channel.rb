# frozen_string_literal: true

class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    current_user.online!
    current_user.open_guest_room if current_user.guest_room&.room_messages.present?
    stream_from "AppearanceChannel"
  end

  def unsubscribed
    current_user.offline!
    current_user.delay_reassign_room if current_user.assigned_rooms.opening.present?
    Room.close_guest_room(current_user.id) if current_user.guest?
  end
end
