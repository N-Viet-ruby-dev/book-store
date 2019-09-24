# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :room_messages
  has_many :rooms, through: :room_messages
  has_many :orders, dependent: :destroy

  validates :fullname, presence: true, uniqueness: { case_sensitive: false }

  enum role: { guest: 0, admin: 1 }
end
