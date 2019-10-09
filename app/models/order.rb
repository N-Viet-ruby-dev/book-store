# frozen_string_literal: true

class Order < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  enum status: { processing: 0, finish: 1, failed: 2 }

  belongs_to :user

  has_many :order_details, dependent: :destroy
  has_many :books, through: :order_details
  has_many :notifications, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
  validates :address, presence: true, length: { maximum: 255 }
  validates :phone_number, presence: true, length: { maximum: 11 }
  validates :card_number, presence: true, length: { maximum: 16 }

  after_create_commit { delay(queue: :high_priority).process_order }

  scope :newest, -> { order id: :desc }

  scope :revenue_month_in_year, lambda { |year|
    finish.where("YEAR(created_at) = ?", year)
          .group("DATE_FORMAT(created_at, '%b')").sum("total_price")
  }

  scope :total_revenue_months_in_years, lambda { |start_year, end_year|
    where("YEAR(created_at) BETWEEN ? AND ?", start_year, end_year)
          .group("DATE_FORMAT(created_at, '%b')", "YEAR(created_at)")
          .pluck("DATE_FORMAT(created_at, '%b')", "SUM(total_price)", "YEAR(created_at)")
  }

  scope :revenue_day_in_month, lambda { |month, year|
    finish.where("DATE_FORMAT(created_at, '%b') = ? AND YEAR(created_at) = ?", month, year)
          .group("DATE_FORMAT(created_at, '%e')").sum("total_price")
  }

  scope :created_between, lambda { |start_year, end_year|
    finish.where("(YEAR(created_at) >= ? AND YEAR(created_at) <= ?)", start_year, end_year)
  }

  scope :best_selling_books_the_month_in_year, lambda { |year, book_name|
    joins(:books).finish.where("YEAR(orders.created_at) = ? AND books.name = ?", year, book_name)
                 .group("orders.created_at")
                 .pluck(Arel.sql("DATE_FORMAT(orders.created_at, '%b')"), Arel.sql("SUM(order_details.quantity)"))
  }

  scope :best_sell_book_in_year, lambda { |year|
    joins(:books)
    .finish.where("YEAR(orders.created_at) = ?", year)
    .group("books.id").order("total DESC").limit("10")
    .pluck(Arel.sql("books.name"), Arel.sql("SUM(order_details.quantity) as total"))
  }

  scope :revenue_bigger_book_in_year, lambda { |year|
    joins(:books).finish.where("YEAR(orders.created_at) = ?", year)
                 .group("books.id").order("total_price DESC").limit("10")
                 .pluck(Arel.sql("books.name"), Arel.sql("SUM(order_details.price) as total_price"))
  }

  scope :revenue_bigger_book_in_month_of_year, lambda { |year, month|
    joins(:books).finish.where("YEAR(orders.created_at) = ? AND MONTH(orders.created_at) = ?", year, month)
                 .group("books.id").order("total_price DESC").limit("10")
                 .pluck(Arel.sql("books.name"), Arel.sql("SUM(order_details.price) as total_price"))
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
      notify = notifications.create!(content: I18n.t("order_success", order_id: id))
      NotificationBroadcastJob.perform_now(notify)
      finish!
    else
      notify = notifications.create!(content: I18n.t("order_unsuccess", order_id: id))
      NotificationBroadcastJob.perform_now(notify)
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
