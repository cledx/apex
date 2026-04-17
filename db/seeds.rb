TAGS = %w[Furniture Antiques Collectibles Electronics Kitchenware Jewelry Artwork Books Tools Appliances Clothing Garden Toys Sports_Equipment Linens Vintage Glassware Music Rugs Cameras]

# Clear existing data (optional - comment out if you want to preserve data)
puts "Clearing existing data..."
WantToBuy.destroy_all
Item.destroy_all
House.destroy_all
User.destroy_all

# Users (admin, customer, manager)
puts "Creating users..."
users_data = [
  { email: "admin@example.com", role: "admin" },
  { email: "customer@example.com", role: "customer" },
  { email: "manager@example.com", role: "manager" }
]

password = "password123"
users_data.each do |attrs|
  User.create!(
    email: attrs[:email],
    password: password,
    password_confirmation: password,
    role: attrs[:role],
    confirmed_at: Time.current
  )
end
puts "Created #{User.count} users."

# Houses (2 houses with full attributes)
puts "Creating houses..."
2.times do
  start_date = Faker::Date.between(from: 1.year.ago, to: Date.current)
  end_date = start_date + 1.day

  House.create!(
    address: Faker::Address.street_address,
    start_date: start_date,
    end_date: end_date,
    owner: Faker::Name.name,
    name: Faker::Lorem.words(number: 2).join(" ").titleize,
    description: Faker::Lorem.paragraphs(number: 2).join("\n\n"),
    tags: TAGS.sample(rand(3..6)),
    total_sales: rand(5000..10000)
  )
end
2.times do
  start_date = Faker::Date.between(from: Date.current + rand(1..30), to: Date.current + rand(30..60))
  end_date = start_date + 1.day

  House.create!(
    address: Faker::Address.street_address,
    start_date: start_date,
    end_date: end_date,
    owner: Faker::Name.name,
    name: Faker::Lorem.words(number: 2).join(" ").titleize,
    description: Faker::Lorem.paragraphs(number: 2).join("\n\n"),
    tags: TAGS.sample(rand(3..6))
  )
end
puts "Created #{House.count} houses."

# Items (10 per house, all attributes set)
puts "Creating items..."
conditions = %w[excellent good fair used new]
House.find_each do |house|
  10.times do
    Item.create!(
      house: house,
      name: Faker::Commerce.product_name,
      price: format("%.2f", rand(10.00..100.00)).to_s,
      tags: TAGS.sample,
      description: Faker::Lorem.paragraph(sentence_count: 3),
      condition: conditions.sample,
      age: ["brand new", "less than 1 year", "1-2 years", "2-5 years", "5+ years"].sample,
      category: Faker::Commerce.department(max: 1)
    )
  end
end
puts "Created #{Item.count} items."

puts "Done! Seeds: #{User.count} users, #{House.count} houses, #{Item.count} items."
