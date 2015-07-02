require 'bundler'
#requires all the gems in the gemfile
Bundler.require('default')

#requires all the other parts of the site.
require_relative 'controllers/TwitterSearch.rb'
require_relative 'controllers/TwitterGraph.rb'
require_relative 'controllers/Settings.rb'
require_relative 'controllers/AutomaticFollowing.rb'
require_relative 'controllers/Following.rb'
require_relative 'controllers/PreviouslyFollowed.rb'
require_relative 'controllers/Login.rb'
require_relative 'controllers/Logout.rb'

include ERB::Util

#automatically escapes html - removes need for adding 'h' to anything in an erb file
set :erb, :escape_html => true

#configures the better errors gem, which displays an error in a readable webpage.
configure :development do
  use BetterErrors::Middleware
end

before do
  config = {
      :consumer_key => '...',
      :consumer_secret => '...',
      :access_token => '...',
      :access_token_secret => '...'
  }
  @client = Twitter::REST::Client.new(config)
  @database = SQLite3::Database.new 'models/database.sqlite'
end

def checkLogin
  redirect '/login' unless session[:logged_in]
end

#Section for basic site functionality - homepage, error pages etc.

get '/' do
  checkLogin
  @active = 'home'
  @tweets = []
  @hash = Hash.new
  results = @client.user_timeline
  @tweets = results.take(50)

  unless @tweets.nil? || @tweets.length == 0
    #by default, the homepage orders company tweets by time
    @sorted_by = 'Time Tweeted'
    @tweets.each do |tweet|
      @hash[tweet.text] = tweet.created_at.strftime('%R on %d/%m/%Y')
    end

    #if the user selects retweets or favourites from the dropdown, order by whatever the user selected
    if params[:order_by] == 'retweets'
      #sorted_by defines what text is displayed in the table header
      @sorted_by = 'Retweets'
      @tweets.each do |tweet|
        #make a hash matching tweets to retweet counts
        @hash[tweet.text] = tweet.retweet_count
      end
      @hash = @hash.sort_by { |tweet, retweets| retweets }.reverse!
    else if params[:order_by] == 'favourites'
       @sorted_by = 'Favourites'
       @tweets.each do |tweet|
         @hash[tweet.text] = tweet.favorite_count
       end
       @hash = @hash.sort_by { |tweet, favourites| favourites }.reverse!
     end
    end
  end

  erb :index
end

post '/posting_tweets' do
  checkLogin
  @message = params[:message]
  unless @message.nil? || @message == ''
    @client.update(@message)
  end
  redirect '/'
end

not_found do
  checkLogin
  erb :not_found
end

get '/rate_limit_exceeded' do
  checkLogin
  erb :rate_limit_exceeded
end
