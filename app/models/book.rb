# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :category
  belongs_to :author
  belongs_to :publisher
  has_many :order_details, dependent: :destroy
end
