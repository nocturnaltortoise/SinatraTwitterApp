require_relative 'AutomaticFollower'

get '/previously_followed' do
	checkLogin
	@most_recent = []
	@no_results = false
	@active = "previously_followed"

	if @params[:run]
		begin
			addUser = %{INSERT INTO followingUsers SELECT user FROM previouslyFollowed WHERE user = ?}
			@database.execute addUser, params[:follow]
			@client.follow(@params[:follow])
			removeUser = %{DELETE FROM previouslyFollowed WHERE user = ?}
			@database.execute removeUser, params[:follow]
		rescue Twitter::Error::TooManyRequests
			redirect '/rate_limit_exceeded'
		end
	end

	if params[:search].nil? || params[:search] == ''

		@most_recent = @database.execute %{SELECT * FROM previouslyFollowed}
	else

		selectUser = %{SELECT user FROM previouslyFollowed WHERE UPPER(user) = UPPER(?)}
		@most_recent = @database.execute selectUser, params[:search]

		if @most_recent.empty?
			@most_recent = @database.execute %{SELECT * FROM previouslyFollowed}
			@no_results = true
		end
	end

	erb :previously_followed
end