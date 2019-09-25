# frozen_string_literal: true

class Room < ApplicationRecord
  enum status: { opening: 0, closed: 1 }

  belongs_to :assignee, class_name: "User", optional: true
  belongs_to :guest, class_name: "User", optional: true
  has_many :room_messages, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def assign_to_admin
    User.select_assignee.assigned_rooms << self
    room_messages.create!(message: I18n.t("greeting"), user_id: assignee_id)
  end

  def update_on_send_message(user)
    room_messages.unprocessed.update_all(status: :processed) if user.admin?
  end
end
