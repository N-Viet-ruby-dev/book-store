# frozen_string_literal: true

10.times do |n|
  Category.create!(name: "Category #{n}")
  Author.create!(name: "Author #{n}")
  Publisher.create!(name: "Publisher #{n}")
end

10.times do |n|
  Book.create!(name: "Book #{n}", price: 1000, total: 10, status: 0,
                  category_id: 1, author_id: 1, publisher_id: 1)
  Book.create!(name: "Book #{n}#{n}", price: 3000, total: 0, status: 1,
                  category_id: 2, author_id: 2, publisher_id: 2)
end
