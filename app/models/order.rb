# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy
  has_many :books, through: :order_details

  enum status: { unfinished: 0, finish: 1 }

  scope :newest, -> { order id: :desc }

  scope :revenue_month_in_year, lambda { |year|
    where("YEAR(created_at) = ?", year)
      .group("DATE_FORMAT(created_at, '%b')").sum("total_price")
  }

  scope :revenue_day_in_month, lambda { |month, year|
    where("DATE_FORMAT(created_at, '%b') = ? AND YEAR(created_at) = ?", month, year)
      .group("DATE_FORMAT(created_at, '%e')").sum("total_price")
  }

  scope :created_between, lambda { |start_year, end_year|
    where("(YEAR(created_at) >= ? AND YEAR(created_at) <= ?)", start_year, end_year)
  }
end
