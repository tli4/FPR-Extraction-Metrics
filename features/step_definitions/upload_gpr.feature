Feature: Integrate data uploaded from PDFs containing GPR data

  Scenario: User navigates to import GPR page
    Given User is authenticated
    And User is on the home page
    When User clicks on the Import GPR Distribution Data button
    Then User should be on the import GPR page

  Scenario: User uploads GPR file to term 2015C
    Given User is authenticated
    And User has uploaded PICA data
    And User is on the import GPR page
    When User fills in Term with 2015C
    And User selects GPR file
    And User clicks on the Upload button
    Then User should see the evaluations page for show
    Then User should see 11 new GPRs imported. 0 evaluation GPRs updated.

  Scenario: User does not select a file to uploaded
    Given User is authenticated
    And User has uploaded PICA data
    And User is on the import GPR page
    When User fills in Term with 2015C
    And User clicks on the Upload button
    Then User should see message stating File not attached, please select file to upload

  Scenario: User selects the wrong filetype to upload
    Given User is authenticated
    And User has uploaded PICA data
    And User is on the import GPR page
    When User fills in Term with 2015C
    When User selects excel file
    And User clicks on the Upload button
    Then User should see message stating There was an error parsing that PDF file. Maybe it is corrupt?

  Scenario: User uploads GPR data with no pre-existing corresponding class
    Given User is authenticated
    And User has uploaded PICA data
    And User is on the import GPR page
    When User fills in Term with 2015C
    And User selects GPR file
    And User clicks on the Upload button
    And User clicks on Faculty Member Data link
    Then User should see the faculty member historical data page
    And User should only see instructors who were in the PICA data

  Scenario: User uploads GPR data with pre-existing corresponding class
    Given User is authenticated
    And User has uploaded matching PICA data
    And User is on the import GPR page
    When User fills in Term with 2015C
    And User selects GPR file
    And User clicks on the Upload button
    And User clicks on Faculty Member Data link
    Then User should see the faculty member historical data page
    And User should only see instructors who were in the GPR data

  Scenario: User wants to integrate GPR data
    Given User is authenticated
    And User has uploaded matching PICA data
    And User is on the import GPR page
    When User fills in Term with 2015C
    And User selects GPR file
    And User clicks on the Upload button
    And User clicks on Faculty Member Data link
    And User clicks on Welch, Jennifer link
    Then User should see a GPR of 3.65

  Scenario: User decides not to upload
    Given User is authenticated
    And User is on the import GPR page
    And User clicks on the Cancel button
    Then User should be on the home page

