# frozen_string_literal: true

class RoomMessage < ApplicationRecord
  enum status: { unprocessed: 0, processed: 1 }

  belongs_to :room
  belongs_to :user

  validates :message, presence: true

  after_create_commit { MessageBroadcastJob.perform_later(self) }
end
