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

puts "creating users"
guest = User.create!(email: "guest@gmail.com", password: "123456")
user2 = User.create!(email: "clemens@gmail.com", password: "123456")
user3 = User.create!(email: "carlos@gmail.com", password: "123456")

Personality.create!(user_id: guest.id)
Personality.create!(user_id: user2.id)
Personality.create!(user_id: user3.id)

puts "users created...creating chatroom"
Chatroom.create!(name: "Forum", user_id: guest.id)

puts "chatroom created...creating events"
event1 = Event.create!(name: "Brunch in the Park Madrid", image: "https://www.neo2.com/wp-content/uploads/2019/07/brunch-in-the-park-madrid-barcelona.jpg", address: "Parque Enrique Tierno Galvan, 28045 Madrid, Spain", description: "Best day-party of Madrid, highly recommend if you enjoy electronic music in the daytime. Ends early in Madrid standards and has the best organisatio as well as prime djs. ", price: 25 )
event2 = Event.create!(name: "Fabrik Madrid", image: "https://www.neo2.com/wp-content/uploads/2019/07/brunch-in-the-park-madrid-barcelona.jpg", address: "Av. de la Industria, 82, 28970 Humanes de Madrid, Madrid, Spain", description: "Big warehouse party. Party guranteed, as all teh perks a party needs will be accomodated. Spacious venue and great music.", price: 30)

puts "events created...creating reviews"
Review.create!(rating: 5, comment: "Had a great time, would totally recommend going. Great atmosphere, day vibes and solid music!", user_id: user3.id, event_id: event1.id )
Review.create!(rating: 2, comment: "Honestly the place was too far and didnt like the music. Pricy and was a bit empty, quite disappointing.", user_id: user2.id, event_id: event1.id )
Review.create!(rating: 5, comment: "If you like to party under the sunshine with some good shades, this event is for you!", user_id: guest.id, event_id: event1.id )

puts "reviews created...creating messages"
Message.create!(content: "Le Marais Walking Tour is so bad. Got there and had to wait hours to get in and when I got there the art was not even that nice.", chatroom_id: Chatroom.last.id, user_id: guest.id)
Message.create!(content: "Really?, Didnt feel that way. It was amazing for me!", chatroom_id: Chatroom.last.id, user_id: user2.id)
Message.create!(content: "Great tour of Le Marais, recommended for families", chatroom_id: Chatroom.last.id, user_id: user3.id)
Message.create!(content: "Best app of all time! Love quickstart!", chatroom_id: Chatroom.last.id, user_id: guest.id)
