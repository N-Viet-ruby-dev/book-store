# frozen_string_literal: true

class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    current_user.online!
    current_user.guest_room.opening! if current_user.guest_room.present?
    stream_from "AppearanceChannel"
  end

  def unsubscribed
    current_user.offline!
    current_user.closed_or_reassigned_room
  end
end
