Feature: Be able to view data in the database

  Scenario: User can sort table of data based on semester
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And User is authenticated
    When User visits the evaluation index page
    When Clicks on header of Term
    Then User should see a table of 9 data rows
    And User should see a link for instructor Brent Walther

  Scenario: User can sort table of data based on Course
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the evaluation index page
    When Clicks on header of Course
    Then User should see a table of 17 data rows

  Scenario: User can sort table of data based on level
    Given There exists 3 group of 2 evaluation records in the database for instructor Brent Walther
    And There exists 1 group of 5 evaluation records in the database for instructor John Smith
    And User is authenticated
    When User visits the evaluation index page
    When Clicks on header of Group by Level
    Then User should see a table of 14 data rows