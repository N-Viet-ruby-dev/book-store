# frozen_string_literal: true

module Manager
  class ChartsController < BaseController
    def index
      @date = Order.all.map { |order| order.created_at.strftime("%Y") }.uniq
    end

    def order_by_year
      @condition_by_year = Order.by_year(params[:year])
      @order_by_month = @condition_by_year.group_by_month(:created_at, format: "%b").count
      render json: @order_by_month
    end

    def order_by_month
      @month = Settings.month[params[:month].to_sym]
      @condition_by_month = Order.by_month_year(@month, params[:year])
      @order_by_month = @condition_by_month.group_by_day(:created_at, format: "%a, %d").count
      render json: @order_by_month
    end
  end
end
