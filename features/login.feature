Feature: login

  Scenario: Correct login information entered
    Given I am on the login page
    When I fill in "email" with "123@gmail.com"
    When I fill in "password" with "123"
    When I press "loginButton" within "form"
    Then I should be on the home page

  Scenario: Incorrect password entered
    Given I am on the login page
    When I fill in "email" with "123@gmail.com"
    When I fill in "password" with "incorrect"
    When I press "Log In" within "form"
    Then I should see "Password or email is incorrect"

  Scenario: Incorrect email address entered
    Given I am on the login page
    When I fill in "email" with "incorrect@gmail.com"
    When I fill in "password" with "123"
    When I press "Log In" within "form"
    Then I should see "Password or email is incorrect"

  Scenario: Logout functioning
    Given I am on the logout page
    Then I should see "You're now logged out."
    Given I am on the homepage
    Then I should be on the login page

  Scenario: User should not be able to access homepage without logging in
    Given I am on the logout page
    Given I am on the homepage
    Then I should be on the login page

  Scenario: User should not be able to access automatic following page without logging in
    Given I am on the automatic following page
    Then I should be on the login page

  Scenario: User should not be able to access settings without logging in
    Given I am on the settings page
    Then I should be on the login page

  Scenario: User should not be able to access twitter search page without logging in
    Given I am on the twitter search page
    Then I should be on the login page

  Scenario: User should not be able to access twitter graph page without logging in
    Given I am on the twitter graph page
    Then I should be on the login page

  Scenario: User should not be able to access the 'page not found' (404) page without logging in
    Given I am on an incorrect page
    Then I should be on the login page