Feature: Combine instructors

  Scenario: User navigates to view faculty FPR data page
    Given User is authenticated
    And User is on the home page
    When User clicks on the View Faculty FPR Data button
    Then User should be on the instructor list page

  Scenario: User navigates to combine instructors page
    Given User is authenticated
    And User is on the home page
    When User clicks on the View Faculty FPR Data button
    Then User should be on the instructor list page
    When User clicks on the Combine button
    Then User should be on the Combine instructors page

  Scenario: User navigates to combine confirm page
    Given User is authenticated
    And User is on the home page
    When User clicks on the View Faculty FPR Data button
    When User clicks on the Combine button
    When User selects Daugherity, Walter from the instructor list
    Then User should be on the confirm combine page

  Scenario: User cancel combine instructors
    Given User is authenticated
    And User is on the home page
    When User clicks on the View Faculty FPR Data button
    When User clicks on the Combine button
    When User selects Daugherity, Walter from the instructor list
    Then User should be on the confirm combine page
    When User clicks on the Cancel button
    Then User should see message stating Combine operation is cancelled.


 