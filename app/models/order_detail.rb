# frozen_string_literal: true

class OrderDetail < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :book, optional: true
  belongs_to :cart, optional: true

  validates :cart, presence: true, allow_nil: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :available_book

  before_update :update_price

  private

  def available_book
    errors.add(:quantity, I18n.t("not_available")) if quantity > book.quantity
  end

  def update_price
    self.price = quantity * book.price
  end

  scope :top_total, lambda { |year|
    joins(:order).where("YEAR(orders.created_at) = ? AND orders.status = 1", year)
                 .group("(order_details.book_id)").order("total desc")
                 .pluck(Arel.sql("DISTINCT SUM(order_details.quantity) as total"))[4]
  }

  scope :top_total_price, lambda { |year|
    joins(:order).where("YEAR(orders.created_at) = ? AND orders.status = 1", year)
                 .group("(order_details.book_id)").order("total_price desc")
                 .pluck(Arel.sql("DISTINCT SUM(order_details.price) as total_price"))[9]
  }

  scope :top_total_price_in_month, lambda { |year, month|
    joins(:order).where("YEAR(orders.created_at) = ? AND MONTH(orders.created_at) = ? AND orders.status = 1", year, month)
                 .group("(order_details.book_id)").order("total_price desc")
                 .pluck(Arel.sql("DISTINCT SUM(order_details.price) as total_price"))[0]
  }
end
