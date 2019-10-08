# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :order

  enum status: { unseen: 0, seen: 1 }

  validates :content, presence: true

  scope :newest, -> { order created_at: :desc }
end
