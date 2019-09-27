# frozen_string_literal: true

module Manager
  class ChartsController < BaseController
    include MonthConcern
    before_action :select_year, only: %i[index compare_between_year]

    def index; end

    def revenue_in_year
      revenue_default = revenue_month_default
      revenue_in_year = Order.revenue_month_in_year params[:year]
      render json: revenue_default.merge(revenue_in_year)
    end

    def revenue_in_month
      revenue_default = days_in_month
      revenue_on_day = Order.revenue_day_in_month params[:month], params[:year]
      render json: revenue_default.merge(revenue_on_day)
    end

    def compare_between_year
      new_year = @year.reject { |year| year == params[:year] }
      render json: new_year
    end

    def compare_year
      revenue = revenue_month_default
      revenue_in_year1 = revenue.merge(Order.revenue_month_in_year params[:year1])
      revenue_in_year2 = revenue.merge(Order.revenue_month_in_year params[:year2])
      render json: { year1: revenue_in_year1, year2: revenue_in_year2 }
    end

    def statistics_by_the_year
      condition = condition_between_year params[:year1], params[:year2]
      statistics_the_year = condition.group("YEAR(created_at)").sum("total_price")
      render json: statistics_the_year
    end

    private

    def select_year
      @year = Order.pluck("YEAR(created_at)").uniq
    end

    def days_in_month
      @month = Settings.month[params[:month].to_sym]
      day_in_month = Time.days_in_month @month, params[:year].to_i
      day_keys_default = (1..day_in_month).map(&:to_s)
      day_values_default = day_keys_default.map { |_value| _value = 0 }
      @day_hash_default = day_keys_default.zip(day_values_default).to_h
    end

    def condition_between_year(year1, year2)
      return Order.created_between(year2, year1) if year1 >= year2

      Order.created_between(year1, year2)
    end
  end
end
