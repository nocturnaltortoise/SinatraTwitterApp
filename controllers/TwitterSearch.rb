isEditing = false
term_to_edit = 0

get '/twitter_search' do
  checkLogin
  @active = 'twitter_search'

  unless @params[:new_search_term].nil? || @params[:new_search_term] == ""
    insertNewTerm = %{INSERT INTO searchTerms VALUES (?);}
    @database.execute insertNewTerm, params[:new_search_term]
  end

  unless @params[:delete].nil?
    removeTerm = %{DELETE FROM searchTerms WHERE searchTerm = ?}
    @database.execute removeTerm, params[:delete]
  end

  unless @params[:edit_term].nil?
    isEditing = true
    term_to_edit = @params[:edit_term]
  end
  @editing = isEditing
  @editingTerm = term_to_edit

  begin
    @db_search_terms = @database.execute %{SELECT * FROM searchTerms}
    erb :twitter_search
  rescue SQLite3::SQLException, SQLite3::CorruptException => db_error
    puts "Database error: #{db_error.message}"
    erb :database_error
  end

end

post '/edit_term' do
  checkLogin
  begin
    updateTerm = %{UPDATE OR IGNORE searchTerms SET searchTerm = ? WHERE searchTerm = ?}
    @database.execute updateTerm, params[:edited_term], term_to_edit
    isEditing = false
    redirect 'twitter_search'
  rescue SQLite3::ConstraintException =>db_error
    already_added = true
  end

end

post '/add_term' do
  checkLogin
  unless @params[:new_search_term].nil? || @params[:new_search_term] == ""
    insertNewTerm = %{INSERT OR IGNORE INTO searchTerms VALUES (?);}
    @database.execute insertNewTerm, params[:new_search_term]
  end

  redirect 'twitter_search'
end

get '/search_results' do
  checkLogin
  @tweets = []
  db_length = @database.execute %{SELECT COUNT(*) FROM searchTerms}
  db_search_terms = @database.execute %{SELECT * FROM searchTerms}

  puts db_search_terms

  unless db_search_terms.nil? || db_length == 0
    search_query = ''

    db_search_terms.each do |search_term|
      search_query = "#{search_query} #{search_term[0]} OR"
    end

    # strips trailing 'OR' and trailing and leading whitespace from search query
    search_query.chomp!(' OR').strip!

    begin
      results = @client.search(search_query)
      @tweets = results.take(150)
    rescue Twitter::Error::TooManyRequests
      redirect :rate_limit_exceeded
    end

    erb :search_results
  end
end