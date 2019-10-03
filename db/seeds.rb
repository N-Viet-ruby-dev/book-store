# frozen_string_literal: true
50.times do |n|
  Category.create!(name: "Category #{n}")
  Author.create!(name: "Author #{n}")
  Publisher.create!(name: "Publisher #{n}")
  User.create!(fullname: Faker::Name.name, email: "email#{n}@gmail.com",
    password: "123123")
end

puts "50 finish"

1000.times do |n|
  Book.create!(name: "Book #{n}", price: Faker::Number.number(digits: 4),
                  total: Faker::Number.number(digits: 2), status: 0,
                  category_id: Category.all.sample.id,
                  author_id: Author.all.sample.id,
                  publisher_id: Publisher.all.sample.id)
end

puts "books finish"

1000.times do |n|
  Order.create!(total_price: Faker::Number.number(digits: 7),
    user_id: User.all.sample.id,
    created_at: Faker::Date.between(from: 10.year.ago, to: 1.year.from_now))
end

puts "orders finish"

1000.times do |n|
  book_id = Book.all.sample.id
  quantity = Faker::Number.number(digits: 1)
  OrderDetail.create!(order_id: Order.all.sample.id,
    book_id: book_id,
    quantity: quantity,
    price: Book.find(book_id).price * quantity)
end
