# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy
  has_many :books, through: :order_details
end
