# frozen_string_literal: true

class RoomBroadcastJob < ApplicationJob
  queue_as :default

  def perform(room, listener_id)
    ActionCable.server.broadcast "room_listener_#{ listener_id }_channel",
      room: room_renderer(room),
      room_id: room.id
  end

  private

  def room_renderer(room)
    RoomsController.render partial: 'rooms/rooms_list', locals: { room: room }
  end
end
