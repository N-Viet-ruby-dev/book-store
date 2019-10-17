# frozen_string_literal: true

class Room < ApplicationRecord
  enum status: { opening: 0, closed: 1 }

  belongs_to :assignee, class_name: "User", optional: true
  belongs_to :guest, class_name: "User"
  has_many :room_messages

  validates :name, presence: true, uniqueness: true

  def assign_to_admin
    User.select_assignee.assigned_rooms << self
    room_messages.create!(message: I18n.t("greeting"), user_id: assignee_id)
  end

  def update_on_send_message(user)
    room_messages.unprocessed.update_all(status: :processed) if user.admin?
  end

  class << self
    def close_guest_room(guest_id)
      guest_room = find_by(guest_id: guest_id)
      guest_room.closed!
      RoomBroadcastJob.perform_later(guest_room)
    end
  end
end
