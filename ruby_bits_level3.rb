# Encapsulation
# Bad - send tweet knows too much, should not be responsible
# for retrieving the user
# Passing around data as strings and numbers breaks encapsulation
# Places using that data need to know how to handle it
send_tweet("Practicing Ruby-Fu!", 14)
def send_tweet(status, owner_id)
  retrieve_user(owner_id)
  ...
end
# Fix that be creating a Tweet class
class Tweet
  attr_accessor ...
  def owner
    retrieve_user(owner_id)
  end
end
tweet = Tweet.new
tweet.status = "Practicing Ruby-Fu!"
tweet.owner_id = current_user.id
send_tweet(tweet)


# Visibility
class User
  def up_vote(friend)
    bump_karma
    friend.bump_karma
  end
  private # by adding private here friend.bump_karma will fail 
  # it cannot be called with an explicit receiver
  protected # can be used instead of private to allow other instances of
  # the same class to call it, but not from outside the class
  def bump_karma
    puts "karma up for #{name}" # This should not be part of the public api 
  end
end
joe = User.new 'joe'
leo = User.new 'leo'
joe.up_vote(leo)


# Inheritance
# Bad duplicated functionality
class Image
  attr_accessor :title, :size, :url
  def to_s
    "#{@title}, #{size}"
  end
end
class Video
  attr_accessor :title, :size, :url
  def to_s
    "#{@title}, #{@size}"
  end
end
# Change this instead to a parent class attachment
class Attachment
  attr_accessor :title, :size, :url
  def to_s
    "#{@title}, #{@size}"
  end
end
class Image < Attachment
end
class Video < Attachment
end
class Video < Attachment
  attr_accessor :duration
end


# Super
  