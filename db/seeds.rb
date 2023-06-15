# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts "Destroying everything"
Bookmark.destroy_all
List.destroy_all
Message.destroy_all
Chatroom.destroy_all
Personality.destroy_all
Review.destroy_all
Event.destroy_all
User.destroy_all

puts "creating user"
guest = User.create!(email: "guest@gmail.com", password: "123456")

Personality.create!(user_id: guest.id)

puts "users created...creating chatroom"
Chatroom.create!(name: "Forum", user_id: guest.id)


puts "chatroom created...creating events"
Event.create!(name: "Brunch in the Park Madrid", image: "https://www.neo2.com/wp-content/uploads/2019/07/brunch-in-the-park-madrid-barcelona.jpg", address: "Parque Enrique Tierno Galvan, 28045 Madrid, Spain", description: "Best day-party", price: 25 )
Event.create!(name: "Fabrik Madrid", image: "https://www.neo2.com/wp-content/uploads/2019/07/brunch-in-the-park-madrid-barcelona.jpg", address: "Av. de la Industria, 82, 28970 Humanes de Madrid, Madrid, Spain", description: "Big warehouse party", price: 30)
