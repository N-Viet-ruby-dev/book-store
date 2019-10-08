# frozen_string_literal: true
book_images = [
  "https://i.pinimg.com/originals/19/f5/f7/19f5f71b440cdbab667206d951043ef9.jpg",
  "https://thegioidohoa.com/wp-content/uploads/2017/08/tong-hop-20-mau-bia-sach-doc-dao-nhat-nam-2017-5.jpg",
  "https://pibook.vn/uploads/products/73308_09_03_17_dung-lang-phi-nhung-ngay-dep-troi.jpg",
  "https://vietnamhoinhap.vn/local/resources/uploads/2_8_2018/mot-lit-nuoc-mat.jpg",
  "https://d1j8r0kxyu9tj8.cloudfront.net/images/15675633470EM9Qw1BZoHWiKX.jpg",
  "https://pibook.vn/uploads/products/7791_08_08_15_toi-bi-bo-bat-coc-.gif",
  "http://vietart.co/blog/wp-content/uploads/2014/01/1_thiet_ke_bia_sach_dep_20.jpg",
  "http://vietart.co/blog/wp-content/uploads/2014/01/6_thiet_ke_bia_sach_dep_20.jpg",
  "http://vietart.co/blog/wp-content/uploads/2014/01/7_thiet_ke_bia_sach_dep_20.jpg",
  "http://vietart.co/blog/wp-content/uploads/2014/01/9_thiet_ke_bia_sach_dep_20.jpg",
  "http://vietart.co/blog/wp-content/uploads/2014/01/10_thiet_ke_bia_sach_dep_20.jpg",
  "http://vietart.co/blog/wp-content/uploads/2014/01/12_thiet_ke_bia_sach_dep_20.jpg",
  "https://thegioidohoa.com/wp-content/uploads/2017/08/tong-hop-20-mau-bia-sach-doc-dao-nhat-nam-2017-6.jpg",
  "https://thegioidohoa.com/wp-content/uploads/2017/08/tong-hop-20-mau-bia-sach-doc-dao-nhat-nam-2017-7.jpg",
  "https://thegioidohoa.com/wp-content/uploads/2017/08/tong-hop-20-mau-bia-sach-doc-dao-nhat-nam-2017.jpg",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQd4YPbDU4DF5FsRghzcEjHKRt2ewwd-mE4O2Zom5fJ2rpWYdXb",
  "https://img.idesign.vn/2018/03/12/77839/idesign-nhung-thiet-ke-bia-sach-dep-nhat-danh-cho-nam-2018-05.jpg"
]

descriptions = [
  "I love you the more in that I believe you had liked me for my own sake and for nothing else.",
  "The most difficult thing is the decision to act, the rest is merely tenacity. The fears are paper tigers.
    You can do anything you decide to do. You can act to change and control your life; and the procedure, the process
    is its own reward.",
  "Do not mind anything that anyone tells you about anyone else. Judge everyone and everything for yourself.",
  "Permanence, perseverance and persistence in spite of all obstacles, discouragements, and impossibilities:
    It is this, that in all things distinguishes the strong soul from the weak.",
  "Coming together is a beginning; keeping together is progress; working together is success.",
  "I will keep smiling, be positive and never give up! I will give 100 percent each time I play. These are always my goals and my attitude.",
  "You're going to go through tough times - that's life. But I say, 'Nothing happens to you, it happens for you.' See the positive in negative events.",
]

author_images = [
  "https://dispatch.barnesandnoble.com/content/dam/ccr/bnstores/Contributor/BN_Authors_LP_DavidBaldacci.jpg",
  "https://29a2c9fde86ba3b26cc5-b46d48c1c3e7071759cdbb9a4a64ab30.ssl.cf2.rackcdn.com/s/1/1444411493/author-photos-160W/101054.jpg",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ9PA-j2_bNFt9g75OURRA4OXB910vo_frAITXbXXz-SdcAOREH",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTw34OPb8GTNd1E-w2RaPDgzlw8jEshiuWUFPtDFsW3FvM36OTv"
]

10.times do |n|
  Category.create!(name: Faker::Book.genre + "#{n}", description: descriptions.sample )
  Author.create!(name: Faker::Book.author + "#{n}", description: descriptions.sample, image_url: author_images.sample )
  Publisher.create!(name: Faker::Book.publisher + "#{n}")
  User.create!(fullname: Faker::Name.name + "#{n}", email: "admin#{n}@gmail.com",
    password: "123123", role: :admin)
end

puts "Category, author, publisher create"

1000.times do |n|
  Book.create!( name: Faker::Book.title + "#{n}",
                price: Faker::Number.number(digits: 2),
                quantity: Faker::Number.number(digits: 2), status: 0,
                category_id: Category.all.sample.id,
                author_id: Author.all.sample.id,
                publisher_id: Publisher.all.sample.id,
                description: descriptions.sample,
                image_url: book_images.sample )
end

puts "1000 books created"

10000.times do |n|
  Order.create!(  total_price: Faker::Number.number(digits: 3),
                  user_id: User.all.sample.id,
                  created_at: Faker::Date.between(from: 10.year.ago, to: Time.now),
                  status: [0, 1].sample )
end

puts "10000 orders create"

20000.times do |n|
  book_id = Book.all.sample.id
  quantity = Faker::Number.number(digits: 1)
  OrderDetail.create!(order_id: Order.all.sample.id,
    book_id: book_id,
    quantity: quantity,
    price: Book.find(book_id).price * quantity)
end

puts "20000 orders detail"
