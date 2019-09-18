# frozen_string_literal: true

class Room < ApplicationRecord
  has_many :room_messages, dependent: :destroy
end
