get '/twitter_graph' do
  checkLogin
  @active = "twitter_graph"
  @db_search_terms = @database.execute %{SELECT * FROM searchTerms}

  def label_days_ago( x )
    return "#{Chronic.parse("#{x} days ago").day}/#{Chronic.parse("#{x} days ago").month}/#{Chronic.parse("#{x} days ago").year}"
  end

  count = 0
  max_tweets = 0
  tweets_in_day = Array.new

  unless (params[:searchterm].nil? || params[:searchterm] == '') && (params[:search].nil? || params[:search] == '')
    if params[:search].nil? || params[:search] == ''
      search_string = params[:searchterm]
    else
      search_string = params[:search]
    end
    puts search_string
    begin
      results = @client.search(search_string)
      @tweets = results.take(150)
    rescue Twitter::Error::TooManyRequests
      redirect :rate_limit_exceeded
    end

    for i in 1..7
      @tweets.each do |tweet|
        tweet_time = tweet.created_at

        if tweet_time.between?(Chronic.parse("#{i+1} days ago 0:00"), Chronic.parse("#{i} days ago 0:00"))

          count = count + 1
        end
      end

      tweets_in_day[i] = count

      if tweets_in_day[i] > max_tweets

        max_tweets = tweets_in_day[i]
      end
      count = 0
    end

    @chart_url = Gchart.line( :data => [ [ tweets_in_day[7],
                                           tweets_in_day[6],
                                           tweets_in_day[5],
                                           tweets_in_day[4],
                                           tweets_in_day[3],
                                           tweets_in_day[2],
                                           tweets_in_day[1]
                                         ], [
                                            ((tweets_in_day[7] + tweets_in_day[6] + tweets_in_day[5]) /3),
                                            ((tweets_in_day[3] + tweets_in_day[2] + tweets_in_day[1]) /3)
                                        ] ],
                             :size => '600x500', #MAX SIZE must be <32,000 pixels
                             :line_colors => '73B9FF,D90000',
                             :axis_with_labels => [ 'x', 'y' ],
                             :axis_labels => [ [   "#{label_days_ago( 7 )}",
                                                   "#{label_days_ago( 6 )}",
                                                   "#{label_days_ago( 5 )}",
                                                   "#{label_days_ago( 4 )}",
                                                   "#{label_days_ago( 3 )}",
                                                   "#{label_days_ago( 2 )}",
                                                   "#{label_days_ago( 1 )}"
                                               ] ],

                             :axis_range => [ nil, [ 0, max_tweets/10, max_tweets ] ],
                             :legend => ["Tweet Number", "Average Tweet Number"] )
    end
  erb :twitter_graph
end