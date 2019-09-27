# frozen_string_literal: true

class RoomListenerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_listener_#{params['listener_id']}_channel"
  end

  def unsubscribed; end
end
