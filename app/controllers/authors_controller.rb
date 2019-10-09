# frozen_string_literal: true

class AuthorsController < ApplicationController
  def index
    @authors = Author.all.page(params[:page]).per(9)
  end

  def show
    @categories = Category.limit(5)
    @authors = Author.limit(5)
    @author = Author.find(params[:id])
    @books = @author.books.includes(:author, :publisher).page(params[:page]).per(9)
  end
end
