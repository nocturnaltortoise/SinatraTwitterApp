def add_already_following
  begin
    followedUsers = @database.execute %{SELECT * FROM followingUsers}
    insert = %{INSERT OR IGNORE INTO followingUsers VALUES(?)}

    if followedUsers.empty?
      @client.friends.each { |user|
        @database.execute insert, user.screen_name
      }
    end
  rescue Twitter::Error::TooManyRequests
    redirect '/rate_limit_exceeded'
  end
end

def add_mentioners
  #puts 'running add_mentioners'
  begin
    @client.mentions.each { |tweet|
      unless tweet.user.screen_name.eql? @client.user.screen_name
        add_to_following_database(tweet.user.screen_name)
      end
    }
  rescue Twitter::Error::TooManyRequests
    redirect '/rate_limit_exceeeded'
  end
end

def add_hashtag_tweeters
  #puts 'running add_hashtag_tweeters'
  @results = []

  #search twitter for all the hashtags
  #any tweet that contains one or more of the hashtags, follow the tweeter

  begin
    unless @db_hashtags.nil? || @db_hashtags.length == 0
      @db_hashtags.each { |hashtag|
        @query = "#{@query} #{hashtag} OR"
      }

      @query.chomp!(' OR').strip!
      @results = @client.search(@query)

      tweets = @results.take(20)

      # tweets.each do |tweet|
      #   puts tweet.text
      # end

      tweets.each { |tweet|
        add_to_following_database(tweet.user.screen_name)
      }
    end

  rescue Twitter::Error::TooManyRequests
    redirect '/rate_limit_exceeded'
  end

end

def add_followers
  #puts 'running add_followers'
  begin
    @client.followers.each { |user|
      add_to_following_database(user.screen_name)
    }
  rescue Twitter::Error::TooManyRequests
    redirect '/rate_limit_exceeded'
  end

end

def add_retweeters
  #puts 'running add_retweeters'
  begin
    @client.retweets_of_me.each { |tweet|
      @client.retweeters_of(tweet).each{ |retweeter| add_to_following_database(retweeter.screen_name) }
    }
  rescue Twitter::Error::TooManyRequests
    redirect '/rate_limit_exceeded'
  end
end

def add_to_following_database(user)
  #puts 'running add_to_following_database'
  followedUsers = @database.execute %{SELECT * FROM followingUsers}

  if followedUsers.empty?
    insertUser = %{INSERT OR IGNORE INTO usersToFollow VALUES(?)}
    @database.execute insertUser, user
  else
    followedUsers.each do |userFollowed|
      unless userFollowed[0] === user
        insertUser = %{INSERT OR IGNORE INTO usersToFollow VALUES(?)}
        @database.execute insertUser, user
      end
    end
  end
end

def followUsers
  #puts 'running followUsers'
  usersInDatabase = @database.execute %{SELECT * FROM usersToFollow}

  #Test
  puts "Users:"
  usersInDatabase.each { |user| puts user}

  usersInDatabase.each{ |user|
    unless @client.user.friends_count >= @client.user.followers_count * 2

      @client.follow(user)

      puts "Trying to insert #{user} into followingUsers"
      insert = %{INSERT OR IGNORE INTO followingUsers VALUES(?)}
      @database.execute insert, user
      puts "Inserted #{user} into followingUsers"

      delete = %{DELETE FROM usersToFollow WHERE user = ?}
      @database.execute delete, user
      puts "Deleted #{user} from usersToFollow"
    end
  }
end