require_relative '../controllers/AutomaticFollower'

isEditing = false
hashtag_to_edit = 0

get '/automatic_following' do
  checkLogin
  @active = 'automatic_following'

  unless @params[:new_hashtag].nil? || @params[:new_hashtag] == ''
    insertNewHashtag = %{INSERT INTO hashtags VALUES (?);}
    @database.execute insertNewHashtag, params[:new_hashtag]
  end

  unless @params[:delete].nil?
    removeHashtag = %{DELETE FROM hashtags WHERE hashtag = ?}
    @database.execute removeHashtag, params[:delete]
  end

  unless @params[:edit_hashtag].nil?
    isEditing = true
    hashtag_to_edit = @params[:edit_hashtag]
  end

  @editing = isEditing
  @editinghashtag = hashtag_to_edit

  begin
    @db_hashtags = @database.execute %{SELECT * FROM hashtags}
    @num_users_in_db = @database.execute %{SELECT COUNT(*) FROM usersToFollow}

    if @params[:run]
      begin

        @friends_count = @client.user.friends_count
        @followers_count = @client.user.followers_count
        @max_friends = @followers_count * 2
        @over_cap = @friends_count > @max_friends

        add_already_following

        add_hashtag_tweeters
        add_followers
        add_mentioners
        add_retweeters

        unless @over_cap
          followUsers
        end
      rescue Twitter::Error::TooManyRequests => requests_error
        puts requests_error.message
        redirect '/rate_limit_exceeded'
      end

      @following_successful = true
    end

    erb :automatic_following
  rescue SQLite3::SQLException, SQLite3::CorruptException => db_error
    puts "Database error: #{db_error.message}"
    erb :database_error
  end

end

post '/edit_hashtag' do
  updateHashtag = %{UPDATE OR IGNORE hashtags SET hashtag = ? WHERE hashtag = ?}
  @database.execute updateHashtag, params[:edited_hashtag], hashtag_to_edit
  isEditing = false
  redirect 'automatic_following'
end

post '/add_hashtag' do

  unless @params[:new_hashtag].nil? || @params[:new_hashtag] == ""
    insertNewHashtag = %{INSERT OR IGNORE INTO hashtags VALUES (?);}
    @database.execute insertNewHashtag, params[:new_hashtag]
  end

  redirect 'automatic_following'
end

