# frozen_string_literal: true

module Manager
  class ChartsController < BaseController
    include MonthConcern
    before_action :select_year, only: %i[index compare_between_year]

    def index; end

    def order_by_year
      month = month_hash_default
      @condition_by_year = Order.by_year(params[:year])
      @order_by_year =
        @condition_by_year.group_by_month(:created_at, format: "%b").count
      render json: month.merge(@order_by_year)
    end

    def order_by_month
      @month = Settings.month[params[:month].to_sym]
      @condition_by_month = Order.by_month_year(@month, params[:year])
      @order_by_month =
        @condition_by_month.group_by_day(:created_at, format: "%a, %d").count
      render json: @order_by_month
    end

    def order_details_by_date
      @month = Settings.month[params[:month].to_sym]
      @order_details_by_day =
        Order.by_month_year_day @month, params[:year], params[:day].split[1]
      render json: @order_details_by_day
    end

    def compare_between_year
      @new_year = @year.reject{|year| year == params[:year]}
      render json: @new_year
    end

    def chart_compare_the_year
      month_hash = month_hash_default
      @condition1 = Order.by_year(params[:year1])
      @condition2 = Order.by_year(params[:year2])
      @order_by_year1 =
        @condition1.group_by_month(:created_at, format: "%b").count
      @order_by_year2 =
        @condition2.group_by_month(:created_at, format: "%b").count
      render json: { year1: month_hash.merge(@order_by_year1), year2: month_hash.merge(@order_by_year2)}
    end

    def statistics_by_the_year
      @condition = Order.created_between(params[:year1], params[:year2])
      @statistics_the_year =
        @condition.group_by_year(:created_at, format: "%Y").count
      render json: @statistics_the_year
    end

    private

    def select_year
      @year = Order.newest.map { |order| order.created_at.strftime("%Y") }.uniq
    end
  end
end
