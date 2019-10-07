# frozen_string_literal: true

class Order < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  enum status: { processing: 0, finish: 1, failed: 2 }

  belongs_to :user

  has_many :order_details, dependent: :destroy
  has_many :books, through: :order_details

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 },
          format: { with: VALID_EMAIL_REGEX }
  validates :address, presence: true, length: { maximum: 255}
  validates :phone_number, presence: true, length: { maximum: 11 }
  validates :card_number, presence: true, length: { maximum: 16 }

  after_create_commit { delay(queue: :high_priority).process_order }

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

  def add_order_details_from_cart(cart)
    cart.order_details.each do |item|
      item.cart_id = nil
      order_details << item
      self.total_price += item.price
    end
  end

  private

  def process_order
    if processing? && check_order_valid?
      except_book_quantity
      finish!
    else
      failed!
    end

  end

  def check_order_valid?
    order_details.select { |detail| detail.quantity > detail.book.quantity }.empty?
  end

  def except_book_quantity
    order_details.each do |detail|
      book = detail.book
      book.update(quantity: book.quantity - detail.quantity)
    end
  end
end
