# frozen_string_literal: true

module Manager
  class ChartBooksController < BaseController
    include MonthConcern

    def index
      @year = Order.pluck(Arel.sql("DISTINCT YEAR(created_at)")).sort.reverse
    end

    def best_selling_books
      render json: Order.best_sell_book_in_year(params[:year]).to_h
    end

    def best_selling_books_in_month
      month = revenue_month_default
      list_book = Order.best_selling_books_the_month_in_year(params[:year], params[:book]).to_h
      render json: month.merge(list_book)
    end

    def book_has_biggest_revenue
      months = Order.where("YEAR(created_at) = ?", params[:year])
                    .pluck(Arel.sql("DISTINCT MONTH(created_at)")).sort
      render json: { top: Order.revenue_bigger_book_in_year(params[:year]).to_h, month: months }
    end

    def book_has_biggest_revenue_in_month
      render json: Order.revenue_bigger_book_in_month_of_year(params[:year], params[:month]).to_h
    end
  end
end
