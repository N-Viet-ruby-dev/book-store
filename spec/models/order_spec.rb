require 'rails_helper'

RSpec.describe Order, type: :model do

  describe Order, "#status" do
    let(:status) { [:processing, :finish, :failed] }

    it "has the right index" do
      status.each_with_index do |item, index|
        expect(described_class.statuses[item]).to eq index
      end
    end
  end

  describe "Associations" do
    it do
      should belong_to(:user)
      should have_many(:order_details).dependent(:destroy)
      should have_many(:books).through(:order_details)
      should have_many(:notifications).dependent(:destroy)
    end
  end

  describe "Validations" do
    it do
      order = FactoryBot.build(:order)
      should validate_presence_of :name
      should validate_length_of(:name).is_at_most(255)
        .with_message("is too long (maximum is 255 characters)")
      should validate_presence_of :email
      should validate_length_of(:email).is_at_most(255)
        .with_message("is too long (maximum is 255 characters)")
      order.email = "wrong_email_format"
      expect(order).to_not be_valid
      should validate_presence_of :address
      should validate_length_of(:address).is_at_most(255)
        .with_message("is too long (maximum is 255 characters)")
      should validate_presence_of :phone_number
      should validate_length_of(:phone_number).is_at_most(11)
        .with_message("is too long (maximum is 11 characters)")
      should validate_presence_of :card_number
      should validate_length_of(:card_number).is_at_most(16)
        .with_message("is too long (maximum is 16 characters)")
    end
  end

  describe "Scope" do
    it "return the order with total revenue months in years" do
      start_year = 2018
      end_year = 2019
      expect(Order.total_revenue_months_in_years(start_year, end_year)).to eq Order.where("YEAR(created_at) BETWEEN ? AND ?", start_year, end_year)
        .group("DATE_FORMAT(created_at, '%b')", Arel.sql("YEAR(created_at)"))
        .pluck(Arel.sql("DATE_FORMAT(created_at, '%b')"), Arel.sql("SUM(total_price)"), Arel.sql("YEAR(created_at)"))
    end

    it "revenue month in year" do
      year = 2019
      expect(Order.revenue_month_in_year(year)).to eq Order.finish.where("YEAR(created_at) = ?", year)
        .group("DATE_FORMAT(created_at, '%b')").sum("total_price")
    end

    it "revenue day in month" do
      month = "Jan"
      year = 2019
      expect(Order.revenue_day_in_month(month, year)).to eq Order.finish.where("DATE_FORMAT(created_at, '%b') = ? AND YEAR(created_at) = ?", month, year)
        .group("DATE_FORMAT(created_at, '%e')").sum("total_price")
    end

    it "created between" do
      start_year = 2018
      end_year = 2019
      expect(Order.created_between(start_year, end_year)).to eq Order.finish.where("(YEAR(created_at) >= ? AND YEAR(created_at) <= ?)", start_year, end_year)
    end

    it "best selling books the month in year" do
      year = 2018
      book_name = "book 0"
      expect(Order.best_selling_books_the_month_in_year(year, book_name)).to eq Order.joins(:books).finish.where("YEAR(orders.created_at) = ? AND books.name = ?", year, book_name)
        .group("books.id").order("total DESC").limit("10")
        .pluck(Arel.sql("books.name"), Arel.sql("SUM(order_details.quantity) as total"))
    end

    it "revenue bigger book in month of year" do
      year = 2019
      month = 1
      expect(Order.revenue_bigger_book_in_month_of_year(year, month)).to eq Order.joins(:books).finish.where("YEAR(orders.created_at) = ? AND MONTH(orders.created_at) = ?", year, month)
        .group("books.id").order("total_price DESC").limit("10")
        .pluck(Arel.sql("books.name"), Arel.sql("SUM(order_details.price) as total_price"))
    end
  end
end
