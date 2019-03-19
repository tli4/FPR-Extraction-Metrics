Feature: Manually enter evaluation data from paper evaluations

  Scenario: User is able to access the manual evaluation entry screen
    Given User is authenticated
    And User is on the home page
    When User clicks on the Add Paper Evaluation button
    Then User be on the add evaluation page

  Scenario: User sees the correct fields on the manual evaluation entry screen
    Given User is authenticated
    When User visits the add evaluation page
    Then User should see input fields for Term, Subject, Course, Section, Responses, Enrollment, Item 1 Mean, Item 2 Mean, Item 3 Mean, Item 4 Mean, Item 5 Mean, Item 6 Mean, Item 7 Mean, Item 8 Mean

  Scenario: User can add a new evaluation manually
    Given There exists 1 group of 5 evaluation records in the database for instructor Brent Walther
    And User is authenticated
    When User visits the add evaluation page
    And User fills in Term with 2015C, Subject with CSCE, Course with 111, Section with 506, Responses with 20, Enrollment with 50, Item 1 Mean with 4.32, Item 2 Mean with 4.32, Item 3 Mean with 4.32, Item 4 Mean with 4.32, Item 5 Mean with 4.32, Item 6 Mean with 4.32, Item 7 Mean with 4.32, Item 8 Mean with 4.32
    And User selects Brent Walther from the Instructor select menu
    And User clicks on the Add Evaluation button
    Then User should be in evaluation page
    And User should see a table of 11 data rows

  Scenario: Administrator is able to access the manual evaluation entry screen
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    And User is on the home page
    When User clicks on the Add Paper Evaluation button
    Then User be on the add evaluation page

  Scenario: Read Write is able to access the manual evaluation entry screen
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class readWrite
    And User is on the home page
    When User clicks on the Add Paper Evaluation button
    Then User be on the add evaluation page
