Feature: Edit enrollment numbers for classes

  Scenario: User can click on the edit button
    Given There exists 5 evaluation record in the database for instructor xyz
    And User is authenticated
    When User visits the evaluation page
    Then User should see a link for Edit for the record

  Scenario: User gets redirected to edit.html page upon clicking edit button in view page
    Given There exists 5 evaluation record in the database for instructor xyz
    And User is authenticated
    When User visits the evaluation page
    And User clicks on Edit link
    Then User should be redirected to evaluation edit page with Done button

  Scenario: User gets redirected to evaluation index page after updating
    Given There exists 5 evaluation record in the database for instructor xyz
    And User is authenticated
    When User is on edit page for user 1
    And User clicks on Done button on edit page
    Then User should be redirected to evaluation index page

  Scenario: User gets redirected to evaluation index page after updating
    Given There exists 5 evaluation record in the database for instructor xyz
    And User is authenticated
    When User is on edit page for user 1
    And User clicks on Cancel button on edit page
    Then User should be redirected to evaluation index page

  Scenario: User gets redirected to evaluation index page after updating
    Given There exists 5 evaluation record in the database for instructor xyz
    And User is authenticated
    When User is on edit page for user 1
    And User clicks on Delete Evaluation button on edit page
    Then User should be redirected to evaluation index page

  Scenario: Guest is able to access the manual evaluation entry screen
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class guest
    And User is on the home page
    Then User should not see the Add Paper Evaluation button

  Scenario: Admin user can click on the edit button
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    And There exists 5 evaluation record in the database for instructor xyz
    When User visits the evaluation page
    Then User should see a link for Edit for the record

  Scenario: Read/Write user can click on the edit button
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class readWrite
    And There exists 5 evaluation record in the database for instructor xyz
    When User visits the evaluation page
    Then User should see a link for Edit for the record

  Scenario: Read Only user cant see the edit button
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class readOnly
    And There exists 5 evaluation record in the database for instructor xyz
    When User visits the evaluation page
    Then User should not see the edit link

  Scenario: Guest user cant click on the edit button
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class guest
    And There exists 5 evaluation record in the database for instructor xyz
    When User visits the evaluation page
    Then User should be on the home page
