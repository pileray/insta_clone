puts 'Start inserting seed "posts" ...'
User.limit(10).each do |user|
  post = user.posts.build(body: Faker::Hacker.say_something_smart)
  post.images.attach(io: File.open('db/fixtures/dummy.jpg'), filename: 'dummy.jpg', content_type: 'image/jpeg')
  post.images.attach(io: File.open('db/fixtures/dummy.jpg'), filename: 'dummy.jpg', content_type: 'image/jpeg')
  post.images.attach(io: File.open('db/fixtures/dummy.jpg'), filename: 'dummy.jpg', content_type: 'image/jpeg')
  post.save
  puts "post#{post.id} has created!"
end
