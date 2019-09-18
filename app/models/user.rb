# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :room_messages, dependent: :destroy
  has_many :orders, dependent: :destroy
end
