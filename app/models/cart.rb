# frozen_string_literal: true

class Cart < ApplicationRecord
  has_many :order_details, dependent: :destroy, inverse_of: :cart
  has_many :books, through: :order_details

  accepts_nested_attributes_for :order_details, allow_destroy: true

  def add_book(book)
    current_item = order_details.find_by(book_id: book.id)
    if current_item
      check_quantity current_item, book
    else
      current_item = order_details.build(book_id: book.id, price: book.price, quantity: 1)
    end
    current_item
  end

  def total_price
    order_details.to_a.sum(&:price)
  end

  private

  def check_quantity(item, book)
    if item.quantity >= book.quantity
      item.errors.add(:quantity, I18n.t("exceed_limit"))
    else
      item.quantity += 1
      item.price += book.price
    end
  end
end
