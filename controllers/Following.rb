require_relative 'AutomaticFollower'

get '/following' do
	checkLogin
	@most_recent = []
	@no_results = false
	@active = "following"

	if @params[:run]
		begin
			addUser = %{INSERT INTO previouslyFollowed SELECT user FROM followingUsers WHERE user = ?}
			@database.execute addUser, params[:unfollow]
			@client.unfollow(@params[:unfollow])
			removeUser = %{DELETE FROM followingUsers WHERE user = ?}
			@database.execute removeUser, params[:unfollow]
		rescue Twitter::Error::TooManyRequests
			redirect '/rate_limit_exceeded'
		end
	end

	if params[:search].nil? || params[:search] == ''

		@most_recent = @database.execute %{SELECT * FROM followingUsers}
	else

		selectUser = %{SELECT user FROM followingUsers WHERE UPPER(user) = UPPER(?)}
		@most_recent = @database.execute selectUser, params[:search]

		if @most_recent.empty?
			@most_recent = @database.execute %{SELECT * FROM followingUsers}
			@no_results = true
		end
	end

	erb :following
end