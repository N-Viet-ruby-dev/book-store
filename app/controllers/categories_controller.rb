# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    @categories = Category.all.page(params[:page]).per(9)
  end

  def show
    @categories = Category.limit(5)
    @authors = Author.limit(5)
    @category = Category.find(params[:id])
    @books = @category.books.includes(:author, :publisher).page(params[:page]).per(9)
  end
end
