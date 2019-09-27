# frozen_string_literal: true

class RoomMessage < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :message, presence: true

  enum status: { unprocessed: 0, processed: 1 }

  after_create_commit { MessageBroadcastJob.perform_later(self) }
end
