# frozen_string_literal: true

class RoomMessage < ApplicationRecord
  belongs_to :room, inverse_of: :room_messages
  belongs_to :user

  after_create_commit { MessageBroadcastJob.perform_later(self) }
end
