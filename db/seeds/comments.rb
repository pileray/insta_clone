puts 'Start inserting seed "comments" ...'
User.limit(2).each do |user|
  Post.limit(10).each do |post|
    comment = user.comments.create(body: Faker::Hacker.say_something_smart, post_id: post.id)
    puts "comment#{comment.id} has created!"
  end
end
