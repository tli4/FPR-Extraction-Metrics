Feature: First user created should be an admin, all others afterwards default to guests

  Scenario: 1 user is created
    Given User is on the home page
    When User clicks on Sign up link
    And User fills in Email with test@man.com, Password with secretpass, Password confirmation with secretpass
    And User clicks on the Create button
    Then User should be on the home page
    And User should see message stating Welcome! You have signed up successfully.

  Scenario: 2 users are created
    Given User is on the home page
    When User clicks on Sign up link
    And User fills in Email with test@man.com, Password with secretpass, Password confirmation with secretpass
    And User clicks on the Create button
    And User clicks on Sign out link
    And User clicks on Sign up link
    And User fills in Email with test2@man.com, Password with secretpass, Password confirmation with secretpass
    And User clicks on the Create button
    Then User should be on the home page
    And User should see please ask an administrator to authorize your account as text
