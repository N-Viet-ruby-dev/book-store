# frozen_string_literal: true

class User < ApplicationRecord
  enum role: { guest: 0, admin: 1 }
  enum online: { offline: 0, online: 1 }

  has_one :guest_room, class_name: "Room", foreign_key: "guest_id"
  has_many :room_messages
  has_many :assigned_rooms, class_name: "Room", foreign_key: "assignee_id"
  has_many :orders, dependent: :destroy

  validates :fullname, presence: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def reassign_room
    return if online? || (Time.now - updated_at < Settings.reassign_time_minute.minutes)

    assigned_rooms.opening.each do |room|
      User.select_assignee.assigned_rooms << room
      RoomBroadcastJob.perform_later(room)
    end
  end

  def delay_reassign_room
    delay(run_at: Settings.reassign_time_minute.minutes.from_now).reassign_room
  end

  def open_guest_room
    guest_room.opening!
    RoomBroadcastJob.perform_later(guest_room)
  end

  class << self
    def select_assignee
      admins = admin.online.present? ? admin.online : admin.offline
      admins.select("users.*, COUNT(rooms.id) rooms").left_joins(:assigned_rooms).group(:id).order(:rooms).first
    end
  end
end
