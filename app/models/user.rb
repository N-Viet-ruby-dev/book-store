# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :room_messages
  has_many :assigned_rooms, class_name: "Room", foreign_key: "assignee_id"
  has_one :room, foreign_key: "guest_id"
  has_many :orders, dependent: :destroy

  validates :fullname, presence: true

  enum role: { guest: 0, admin: 1 }
  enum online: { offline: 0, online: 1 }

  class << self
    def select_assignee
      admins = admin.online.present? ? admin.online : admin.offline
      admins.select("users.*, COUNT(rooms.id) rooms").left_joins(:assigned_rooms).group(:id).order(:rooms).first
    end
  end
end
