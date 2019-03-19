Feature: All actions should be checked against user roles.

  Scenario: User without write access tries to access /evaluation/new
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    And User has uploaded PICA data
    And User clicks on Sign out link
    And User is of class readOnly
    When User directly visits /evaluation/new
    Then User should be on page with path of /evaluation/show

  Scenario: User without read access tries to access /evaluation
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class guest
    When User directly visits /evaluation
    Then User should be on page with path of /

  Scenario: User without read access tries to access /evaluation/show
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class guest
    When User directly visits /evaluation/show
    Then User should be on page with path of /

  Scenario: User without read access tries to access /evaluation/missing_data
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class guest
    When User directly visits /evaluation/missing_data
    Then User should be on page with path of /

  Scenario: User without write access tries to access /evaluation/import
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    And User has uploaded PICA data
    And User clicks on Sign out link
    And User is of class readOnly
    When User directly visits /evaluation/import
    Then User should be on page with path of /evaluation/show

  Scenario: User without write access tries to access /evaluation/import_gpr
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    And User has uploaded PICA data
    And User clicks on Sign out link
    And User is of class readOnly
    When User directly visits /evaluation/import_gpr
    Then User should be on page with path of /evaluation/show

  Scenario: User without read access tries to access /evaluation/export
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class guest
    When User directly visits /evaluation/export
    Then User should be on page with path of /

  Scenario: User without write access tries to access /evaluation/1/edit
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    And User has uploaded PICA data
    And User clicks on Sign out link
    And User is of class readOnly
    When User directly visits /evaluation/1/edit
    Then User should be on page with path of /evaluation/show

  Scenario: User without read access tries to access /instructor
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class guest
    When User directly visits /instructor
    Then User should be on page with path of /
