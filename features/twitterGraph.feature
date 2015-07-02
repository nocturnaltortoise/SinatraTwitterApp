Feature: Graph displaying change in tweets containing a certain string over 7 days

  Background:
    Given I am on the login page
    When I fill in "emailInput" with "123@gmail.com"
    When I fill in "passwordInput" with "123"
    When I press "loginButton" within "form"

  Scenario: Clicking on the link to the Twitter graph page should take you there
    Given I am on the homepage
    When I follow "Twitter Graph"
    Then I should be on the twitter graph page

  Scenario: Searching for a suitable search term should return a graph image
    Given I am on the twitter graph page
    When I fill in "search" with "com1001"
    When I press "Submit"
    Then I should see a "results_graph" image