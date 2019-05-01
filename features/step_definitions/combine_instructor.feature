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
    When User clicks on the Combine Instructor button
    Then User should be on the Combine instructors page

  Scenario: User navigates to combine confirm page
    Given There exists 5 instructor in the database
    Given User is authenticated
    And User is on the home page
    When User clicks on the View Faculty FPR Data button
    When User clicks on the Combine Instructors button
    When User selects 1 from the instructor list
    When User selects 2 from the instructor list
    When User clicks on the Combine button
    Then User should be on the confirm combine page

  Scenario: User combine two instructor
    Given There exists 5 instructor in the database
    Given User is authenticated
    And User is on the home page
    When User clicks on the View Faculty FPR Data button
    When User clicks on the Combine Instructors button
    When User selects 1 from the instructor list
    When User selects 2 from the instructor list
    When User clicks on the Combine button
    Then User should be on the confirm combine page
    When User clicks on the Combine button
    Then User should be on the instructor list page
    Then User should see message stating Combine operation is successful.

  Scenario: User cancel combine instructors
    Given There exists 5 instructor in the database
    Given User is authenticated
    And User is on the home page
    When User clicks on the View Faculty FPR Data button
    When User clicks on the Combine Instructors button
    When User selects 1 from the instructor list
    When User selects 2 from the instructor list
    When User clicks on the Combine button
    Then User should be on the confirm combine page
    When User clicks on the Cancel button
    Then User should be on the instructor list page
    Then User should see message stating Combine operation is cancelled.

  Scenario: User does not select instructor
  	Given User is authenticated
    And User is on the home page
    When User clicks on the View Faculty FPR Data button
    When User clicks on the Combine Instructors button
    When User clicks on the Combine button
    Then User should see message stating No instructor is selected. Combine operation is cancelled.


   


 