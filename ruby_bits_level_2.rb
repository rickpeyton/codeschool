####################
# Optional Arguments
# Bad
def tweet(message, lat, long)
  #...
end

# But location isn't always used, so add defaults
# Good
def tweet(message, lat = nil, long = nil)
  #...
end
tweet("Practicing Ruby-Fu!") #now lat and long are not required.


################################################
# Named Arguments - Hash (a long parameter list)
# Bad
def tweet(message, lat = nil, long = nil, reply_id = nil)
  #...
end
# Calls are hard to read
tweet("Practicing Ruby-Fu!", 28.55, -81.33, 227946)
# Even worse...
tweet("Practicing Ruby-Fu!", nil, nil, 227946)


#############################
# Use a Hash Argument instead
def tweet(message, options = {})
  status = Status.new
  status.lat = options[:lat]
  status.long = options[:long]
  status.body = message
  status.reply_id = options[:reply_id]
  status.post
end

# Calling the method above
# With Ruby 1.9 Hash syntax (like json)
tweet("Practicing Ruby-Fu!",
  :lat => 28.55,
  :long => -81.33,
  :reply_id => 227946
) 
# order is option and complete hash is option (can omit options)


############
# Exceptions
# Bad
def get_tweets(list)
  if list.authorized?(@user)
    list.tweets
  else
    []
  end
end

tweets = get_tweets(my_list)
if tweets.empty?
  alter "No tweets were found!" +
    "Are you authorized to access this list?"
end
# can't be totally sure this is an error

# Good (use an exception)
def get_tweets(list)
  unless list.authorized?(@user)
    raise AuthorizedException.new
  end
  list.tweets
end

begin
  tweets = get_tweets(my_list)
rescue AuthorizedException
  warn "You are not authorized to access this list."
end


###################
# "Splat" Arguments
def mention(status, *names)
  tweet("#{names.join(' ')} #{status}")
end

mention('Your courses rocked!', 'eallam', 'greggpollack', 'jasonvanlue')


##########################
# You need a class when...
# Bad
user_names = [
  ["Ashton", "Kutcher"],
  ["Wil", "Wheaton"],
  ["Madonna"]
]
user_names.each { |n| puts "#{n[1]}, #{n[0]}" }
# prints , Madonna. Users shouldn't have to deal with edge cases

# Good!
class Name
  def inialize(first, last = nil)
    @first = first
    @last = last
  end
  def format
    [@last, @first].compact.join(', ')
  end
end

user_names = []
user_names << Name.new('Ashton', 'Kutcher')
user_names << Name.new('Wil', 'Wheaton')
user_names << Name.new('Madonna')
user_names.each { |n| puts n.format }


##############
# Oversharing?
attr_accessor :baz
# is the same as
def baz=(value)
  @baz = value
end
def baz
  @baz
end


#######################
# Oversharing Continued
class Tweet
  attr_accessor :status, :created_at
  def initialize(status)
    @status = status
    @created_at = Time.new
  end
end

tweet = Tweet.new("Eating breakfast.")
tweet.created_at = Time.new(2084, 1, 1, 0, 0, 0, "-07:00") # Should
  # not be able to do this!

# Simple fix...
class Tweet
  attr_accessor :status
  attr_reader :created_at # Doesn't define a setter!
  def initialize(status)
    @status = status
    @created_at = Time.new
  end
end

tweet = Tweet.new("Eating breakfast.")
tweet.created_at = Time.new(2084, 1, 1, 0, 0, 0, "-07:00") # now this
  # will fail as an undefined method


####################
# Re-opening Classes
tweet = Tweet.new("Eating lunch.")
puts tweet.to_s
# result = #<Tweet:0x000001008c89e8> .. not readable!

# so just re-open the class and redefine it!
class Tweet
  def to_s
    "#{@status}\n#{@created_at}"
  end
end

# now this creates an output that is much more readable
tweet = Tweet.new("Eating lunch.")
puts tweet.to_s
# Eating lunch.
# 2012-08-02 12:20:02 -0700

# You can re-open and change any class
# But beware! You don't know who relies on the old functionality
# Only do this to classes that you own and are part of your project


######
# Self
# Bad
class UserList
  attr_accessor :name
  def initialize(name)
    name = name
  end
end
list = UserList.new('celebrities')
list.name # this is nil and will fail

# Good
class UserList
  attr_accessor :name
  def initialize(name)
    self.name = name # this calls name= on the current object
  end
end
list = UserList.new('celebrities')
list.name # this is nil and will fail




