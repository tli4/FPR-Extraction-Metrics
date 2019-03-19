Feature: Changing of user roles

  Scenario: Administrator can access user management panel
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    When User clicks on the User Management Panel button
    Then User should be on the admin pages

  Scenario: Administrator can change other users to readWrite
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    When User clicks on the User Management Panel button
    And User changes guest user to readWrite
    Then guest user should now have role readWrite

  Scenario: Administrator can change other users to readOnly
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    When User clicks on the User Management Panel button
    And User changes guest user to readOnly
    Then guest user should now have role readOnly

  Scenario: Administrator can change other users to Administrator
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    When User clicks on the User Management Panel button
    And User changes guest user to admin
    Then guest user should now have role admin

  Scenario: Administrator can change readWrite users to guest
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    When User clicks on the User Management Panel button
    And User changes readWrite user to guest
    Then readWrite user should now have role guest

  Scenario: Administrator can change readOnly users to guest
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    When User clicks on the User Management Panel button
    And User changes readOnly user to guest
    Then readOnly user should now have role guest

  Scenario: There should always be at least 1 administrator if users are changed to Read/Write
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    When User clicks on the User Management Panel button
    And User changes admin user to readWrite
    Then User should see message stating Minimum of 1 administrator required
    And There should be at least 1 admin

  Scenario: There should always be at least 1 administrator if users are changed to Read Only
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    When User clicks on the User Management Panel button
    And User changes admin user to readOnly
    Then User should see message stating Minimum of 1 administrator required
    And There should be at least 1 admin

  Scenario: There should always be at least 1 administrator if users are changed to Guest
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    When User clicks on the User Management Panel button
    And User changes admin user to guest
    Then User should see message stating Minimum of 1 administrator required
    And There should be at least 1 admin

  Scenario: There should always be at least 1 administrator if users are removed
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    When User clicks on the User Management Panel button
    And User changes admin user to remove
    Then User should see message stating Minimum of 1 administrator required
    And There should be at least 1 admin

  Scenario: Administrator can remove users
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class admin
    When User clicks on the User Management Panel button
    And User changes guest user to remove
    Then User should see a table of 3 data rows

  Scenario: non-admin attempts to access user management panel
    Given There exists 4 users assigned admin, readWrite, readOnly, and guest as roles
    And User is of class readWrite
    When User visits user management panel page
    Then User should be on the home page
