puts 'Start inserting seed "posts" ...'
User.limit(10).each do |user|
  post = user.posts.create(body: Faker::Hacker.say_something_smart)
  post.images.attach(io: File.open('db/fixtures/dummy.jpg'), filename: 'dummy.jpg', content_type: 'image/jpeg')
  post.images.attach(io: File.open('db/fixtures/dummy.jpg'), filename: 'dummy.jpg', content_type: 'image/jpeg')
  post.images.attach(io: File.open('db/fixtures/dummy.jpg'), filename: 'dummy.jpg', content_type: 'image/jpeg')
  puts "post#{post.id} has created!"
end
