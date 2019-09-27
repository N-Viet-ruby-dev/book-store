# frozen_string_literal: true

class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :book

  # scope :get_order_details_by_date, ->(date) do
  #   joins("order", "books").where(created_at: date)
  # end
end
