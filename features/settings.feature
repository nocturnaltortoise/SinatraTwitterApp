Feature: Changing login email and password

  Scenario: Clicking link to change email page works correctly
    Given I am on the login page
    When I fill in "emailInput" with "123@gmail.com"
    When I fill in "passwordInput" with "123"
    When I press "loginButton" within "form"
    Given I am on the settings page
    When I follow "Change your email address"
    Then I should be on the change email page

  Scenario: Clicking link to change password page works correctly
    Given I am on the login page
    When I fill in "emailInput" with "123@gmail.com"
    When I fill in "passwordInput" with "123"
    When I press "loginButton" within "form"
    Given I am on the settings page
    When I follow "Change your password"
    Then I should be on the change password page

  Scenario: Filling in correct fields to change password should work
    Given I am on the login page
    When I fill in "emailInput" with "123@gmail.com"
    When I fill in "passwordInput" with "123"
    When I press "loginButton" within "form"
    Given I am on the change password page
    When I fill in "current_password" with "123"
    When I fill in "new_password1" with "dog"
    When I fill in "new_password2" with "dog"
    When I press "Change password"
    Then I should be on the settings page
    Given I am on the logout page
    Given I am on the login page
    When I fill in "emailInput" with "123@gmail.com"
    When I fill in "passwordInput" with "dog"
    When I press "loginButton" within "form"
    Then I should be on the homepage

  Scenario: Re-entering a new password incorrectly on the change password page
    Given I am on the login page
    When I fill in "emailInput" with "123@gmail.com"
    When I fill in "passwordInput" with "dog"
    When I press "loginButton" within "form"
    Given I am on the change password page
    When I fill in "current_password" with "dog"
    When I fill in "new_password1" with "cat"
    When I fill in "new_password2" with "chat"
    When I press "Change password"
    Then I should see "The passwords don't match"

  Scenario: Entering old password incorrectly on change password page
    Given I am on the login page
    When I fill in "emailInput" with "123@gmail.com"
    When I fill in "passwordInput" with "dog"
    When I press "loginButton" within "form"
    Given I am on the change password page
    When I fill in "current_password" with "blog"
    When I fill in "new_password1" with "cat"
    When I fill in "new_password2" with "cat"
    When I press "Change password"
    Then I should see "The password was incorrect"

  Scenario: Trying to change email address to empty string should fail
    Given I am on the login page
    When I fill in "emailInput" with "123@gmail.com"
    When I fill in "passwordInput" with "dog"
    When I press "loginButton" within "form"
    Given I am on the change email page
    When I fill in "emailInput" with ""
    When I press "Change email"
    Then I should see "Please fill in the field"

  Scenario: Changing email address should work
    Given I am on the login page
    When I fill in "emailInput" with "123@gmail.com"
    When I fill in "passwordInput" with "dog"
    When I press "loginButton" within "form"
    Given I am on the change email page
    When I fill in "emailInput" with "dog@gmail.com"
    When I press "Change email"
    Then I should be on the settings page
    Given I am on the logout page
    Given I am on the login page
    When I fill in "emailInput" with "dog@gmail.com"
    When I fill in "passwordInput" with "dog"
    When I press "loginButton" within "form"
    Then I should be on the homepage


  Scenario: Changing login information back to original (CLEANUP)
    Given I am on the login page
    When I fill in "emailInput" with "dog@gmail.com"
    When I fill in "passwordInput" with "dog"
    When I press "loginButton" within "form"
    Given I am on the change password page
    When I fill in "current_password" with "dog"
    When I fill in "new_password1" with "123"
    When I fill in "new_password2" with "123"
    When I press "Change password"
    Then I should be on the settings page
    Given I am on the change email page
    When I fill in "emailInput" with "123@gmail.com"
    When I press "Change email"
    Then I should be on the settings page