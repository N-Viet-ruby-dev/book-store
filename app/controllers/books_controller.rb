# frozen_string_literal: true

class BooksController < ApplicationController
  layout "home_books", only: "home"

  before_action :load_entity, only: %i[index show]

  def index
    @books = Book.includes(:author, :publisher).page(params[:page]).per(9)
  end

  def show; end

  def home
    @authors = Author.limit(2)
    @categories = Category.limit(4)
    @exciting_books = Book.limit(3)
    @best_sellers = Book.select("books.*, SUM(order_details.quantity) sum").joins(:order_details)
                        .group(:id).order(sum: :desc).limit(3)
  end

  private

  def load_entity
    @book = Book.find(params[:id]) if params[:id]
    @categories = Category.limit(5)
    @authors = Author.limit(5)
  end
end
