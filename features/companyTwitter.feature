Feature: Company Twitter account

  Background:
    Given I am on the login page
    When I fill in "emailInput" with "123@gmail.com"
    When I fill in "passwordInput" with "123"
    When I press "loginButton" within "form"

  Scenario: Tweeting acceptable tweet from company account
    Given I am on the homepage
    When I fill in "message" with a random string
    When I press "Tweet" within "form"
    Then I should see the random string
    Given I am on the logout page

  Scenario: Trying to send an empty tweet should fail
    Given I am on the homepage
    When I fill in "message" with ""
    Then I should see a disabled "Tweet" button within "form"
    Given I am on the logout page