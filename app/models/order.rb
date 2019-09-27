# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy
  has_many :books, through: :order_details

  scope :by_year, ->(year) { where("YEAR(created_at) = ?", year) }
  scope :by_month_year, (lambda do |month, year|
    where("MONTH(created_at) = ? AND YEAR(created_at) = ?", month, year)
  end)
end
