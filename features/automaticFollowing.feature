Feature: Automatically following and unfollowing users (ENSURE DB IS CLEARED BEFORE RUNNING)

  Background:
    Given I am on the login page
    When I fill in "emailInput" with "123@gmail.com"
    When I fill in "passwordInput" with "123"
    When I press "loginButton" within "form"

  Scenario: Not able to add empty search term
    Given I am on the automatic following page
    When I fill in "new_hashtag" with ""
    When I press "+"
    Then I should see "No hashtags in your list!"
    Given I am on the logout page

  Scenario: Correctly adds search term to database
    Given I am on the automatic following page
    When I fill in "new_hashtag" with a random string
    When I press "+"
    Then I should not see "No hashtags in your list!"
    Then I should see the random string within a "hashtag" field
    Given I am on the logout page

  Scenario: The delete button removes the search term from the db
    Given I am on the automatic following page
    When I fill in "new_hashtag" with a random string
    When I press "+"
    When I press the delete button for the random string
    Then I should not see the random string within a "hashtag" field

  Scenario: The edit button should allow you to edit a term
    Given I am on the automatic following page
    When I fill in "new_hashtag" with a random string
    When I press "+"
    When I press the edit hashtag button for the random string
    When I fill in "edited_hashtag" with "cat"
    When I press "Save"
    Then I should see "cat" within a "hashtag" field
    Then I should not see the random string within a "hashtag" field

  Scenario: Adding a duplicate term should be ignored (checks no server errors are caused)
    Given I am on the automatic following page
    When I fill in "new_hashtag" with "cat"
    When I press "+"
    When I fill in "new_hashtag" with "cat"
    When I press "+"
    Then I should see "cat" within a "hashtag" field