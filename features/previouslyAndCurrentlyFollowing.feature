Feature: Users being and previously followed (Follow instructions in README before running)

  Background:
    Given I am on the login page
    When I fill in "emailInput" with "123@gmail.com"
    When I fill in "passwordInput" with "123"
    When I press "loginButton" within "form"

  Scenario: Page shows list of users being followed
    Given I am on the following page
    Then I should see "@morphashark"

  Scenario: I should not be able to search for a blank string
    Given I am on the following page
    Then I should see a disabled "Submit" button
    Given I am on the previously followed page
    Then I should see a disabled "Submit" button

  Scenario: I can search for correct user on the following page
    Given I am on the following page
    When I fill in "search" with "com1001t2"
    When I press "Submit"
    Then I should see "@com1001t2"
    Then I should not see "@morphashark"

  Scenario: I can unfollow a user
    Given I am on the following page
    When I press the unfollow button for "com1001t2"
    Then I should not see "@com1001t2"
    Given I am on the previously followed page
    Then I should see "@com1001t2"

  Scenario: I can search for correct user on the previously followed page
    Given I am on the previously followed page
    When I fill in "search" with "com1001t2"
    When I press "Submit"
    Then I should see "@com1001t2"

  Scenario: I can follow a user previously unfollowed
    Given I am on the previously followed page
    Then I should see "@com1001t2"
    When I press the follow button for "com1001t2"
    Then I should not see "com1001t2"
    Given I am on the following page
    Then I should see "com1001t2"

