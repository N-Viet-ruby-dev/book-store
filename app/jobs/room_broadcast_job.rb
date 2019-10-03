# frozen_string_literal: true

class RoomBroadcastJob < ApplicationJob
  queue_as :default

  def perform(room, user_role)
    ActionCable.server.broadcast "room_listener_#{room.assignee_id}_channel",
                                 room: room_renderer(room),
                                 room_id: room.id,
                                 user: user_role
  end

  private

  def room_renderer(room)
    RoomsController.render partial: "rooms/rooms_list", locals: { room: room }
  end
end
