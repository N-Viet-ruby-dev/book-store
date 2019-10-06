# frozen_string_literal: true

class Book < ApplicationRecord
  enum status: { available: 0, unavailable: 1 }

  belongs_to :category
  belongs_to :author
  belongs_to :publisher
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_destroy :ensure_not_referenced_by_any_order_detail

  private

  def ensure_not_referenced_by_any_order_detail
    return if order_details.empty?

    errors.add(:base, I18n.t("order_present"))
    throw :abort
  end
end
