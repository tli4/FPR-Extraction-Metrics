Feature: Integrate data uploaded from excel files that were previously calculated

  Scenario: User navigates to import data page
    Given User is authenticated
    And User is on the home page
    When User clicks on the Import Historical Data button
    Then User should be on the import history page

  Scenario: User uploads excel file
    Given User is authenticated
    And User is on the import history page
    When User selects historical excel file
    And User clicks on the Upload button
    Then User should see the evaluations page for show
    And User should see 6 new evaluations imported. 0 evaluations updated.

  Scenario: User uploads a non-excel file
    Given User is authenticated
    And User is on the import history page
    When User selects a non-excel file
    And User clicks on the Upload button
    Then User should be on the import history page
    And User should see message stating There was an error parsing your Excel file. Maybe it is corrupt?

  Scenario: User does not select a file to uploaded
    Given User is authenticated
    And User is on the import history page
    And User clicks on the Upload button
    Then User should see message stating File not attached, please select file to upload

  Scenario: User decides not to upload
    Given User is authenticated
    And User is on the import history page
    And User clicks on the Cancel button
    Then User should be on the home page