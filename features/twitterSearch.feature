Feature: Twitter search + search term database (ENSURE DB IS CLEARED BEFORE RUNNING)

  Background:
    Given I am on the login page
    When I fill in "emailInput" with "123@gmail.com"
    When I fill in "passwordInput" with "123"
    When I press "loginButton" within "form"

  Scenario: Unable to add empty search term
    Given I am on the twitter search page
    When I fill in "new_search_term" with ""
    When I press "+"
    Then I should see "No search terms in your list!"
    Given I am on the logout page

  Scenario: Trying to search with empty list of search terms fails
    Given I am on the twitter search page
    Then I should see a disabled "Automatic Search" button

  Scenario: Correctly adds search term to database
    Given I am on the twitter search page
    When I fill in "new_search_term" with a random string
    When I press "+"
    Then I should not see "No search terms in your list!"
    Then I should see the random string within a "search_term" field
    Given I am on the logout page

  Scenario: The delete button removes the search term from the database
    Given I am on the twitter search page
    When I fill in "new_search_term" with a random string
    When I press "+"
    When I press the delete button for the random string
    Then I should not see the random string within a "search_term" field

  Scenario: The edit button should allow you to edit a term
    Given I am on the twitter search page
    When I fill in "new_search_term" with a random string
    When I press "+"
    When I press the edit button for the random string
    When I fill in "edited_term" with "dog"
    When I press "Save"
    Then I should see "dog" within a "search_term" field
    Then I should not see the random string within a "search_term" field
    When I press the delete button for "dog"

  Scenario: The automatic search button should bring up search results
    Given I am on the twitter search page
    When I fill in "new_search_term" with "com1001"
    When I press "+"
    When I press "Automatic Search"
    Then I should be on the search results page
    Then I should see "com1001"