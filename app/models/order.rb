# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy
  has_many :books, through: :order_details

  scope :newest, -> { order id: :desc }
  scope :by_year, ->(year) { where("YEAR(created_at) = ?", year) }
  scope :by_month_year, (lambda do |month, year|
    where("MONTH(created_at) = ? AND YEAR(created_at) = ?", month, year)
  end)
  scope :created_between, (lambda do |start_year, end_year|
    where("YEAR(created_at) >= ? AND YEAR(created_at) <= ?", start_year, end_year)
  end)

  def self.by_month_year_day(month, year, day)
    joins(:books)
      .where("MONTH(orders.created_at) = ? AND YEAR(orders.created_at) = ? AND DAY(orders.created_at) = ?", month, year, day)
      .group("books.id")
      .pluck("books.name", "SUM(`order_details`.`quantity`)")
  end
end
