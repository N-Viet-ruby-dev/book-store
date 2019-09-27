# frozen_string_literal: true

module MonthConcern
  extend ActiveSupport::Concern

  def revenue_month_default
    { "Jan" => 0, "Feb" => 0, "Mar" => 0, "Apr" => 0, "May" => 0, "Jun" => 0,
      "Jul" => 0, "Aug" => 0, "Sep" => 0, "Oct" => 0, "Nov" => 0, "Dec" => 0 }
  end
end
