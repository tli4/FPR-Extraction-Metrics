Feature: Be able to navigate to other pages from home page

  Scenario: User wants to view evaluation data
    Given There exists 1 group of 5 evaluation records in the database for instructor Brent Walther
    Given User is on the home page
    And User is authenticated
    When User clicks on the View Evaluation Data button
    Then User should see the evaluations page for show

  Scenario: User wants to view faculty member historical data
    Given User is on the home page
    And User is authenticated
    When User clicks on the View Faculty FPR Data button
    Then User should see the faculty member historical data page

  Scenario: Admin user first loads webapp
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    Then User should be on the home page
    And User should see Teaching Evaluation Scores as text
    And User should see the User Management Panel button
    And User should see the Import PICA Evaluation Data button
    And User should see the Import GPR Distribution Data button
    And User should see the Import Course Names button
    And User should see the Add Paper Evaluation button
    And User should see the View Evaluation Data button
    And User should see the View Missing Data button
    And User should see the View Faculty FPR Data button
    And User should see the View Course Names button
    And User should see the Sign out link

  Scenario: Read/Write user first loads webapp
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class readWrite
    Then User should be on the home page
    And User should see Teaching Evaluation Scores as text
    And User should not see the User Management Panel button
    And User should see the Import PICA Evaluation Data button
    And User should see the Import GPR Distribution Data button
    And User should see the Add Paper Evaluation button
    And User should see the Import Course Names button
    And User should see the View Evaluation Data button
    And User should see the View Missing Data button
    And User should see the View Faculty FPR Data button
    And User should see the View Course Names button
    And User should see the Sign out link
    

  Scenario: Read Only user first loads webapp
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class readOnly
    Then User should be on the home page
    And User should see Teaching Evaluation Scores as text
    And User should not see the User Management Panel button
    And User should not see the Import PICA Evaluation Data button
    And User should not see the Import GPR Distribution Data button
    And User should not see the Add Paper Evaluation button
    And User should see the View Evaluation Data button
    And User should see the View Missing Data button
    And User should see the View Faculty FPR Data button
    And User should see the View Course Names button
    And User should see the Sign out link

  Scenario: Guest user first loads webapp
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class guest
    Then User should be on the home page
    And User should see Teaching Evaluation Scores as text
    And User should not see the User Management Panel button
    And User should not see the Import PICA Evaluation Data button
    And User should not see the Import GPR Distribution Data button
    And User should not see the Add Paper Evaluation button
    And User should not see the View View Evaluation Data button
    And User should not see the View Missing Data button
    And User should not see the View Faculty FPR Data button
    And User should see please ask an administrator to authorize your account as text
    And User should see the Sign out link
