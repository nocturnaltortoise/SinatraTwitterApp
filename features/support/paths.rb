module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    when /the login\s?page/
      '/login'

    when /the automatic following page/
      '/automatic_following'

    when /the twitter search page/
      '/twitter_search'

    when /the twitter graph page/
      '/twitter_graph'

    when /the settings page/
      '/settings'
    
    when /the logout page/
      '/logout'

    when /the search results page/
      '/search_results'

    when /an incorrect page/
      '/madeup_page_blah'

    when /the change email page/
      '/change_email'

    when /the change password page/
      '/change_password'

    when /the database error page/
      '/database_error'

    when /the following page/
      '/following'

    when /the previously followed page/
      '/previously_followed'

    when /the Twitter rate limit exceeded error page/
      '/rate_limit_exceeded'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"

    end
  end
end

World(NavigationHelpers)
