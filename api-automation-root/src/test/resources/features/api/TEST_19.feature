Feature: Test Logout and Token Revocation API
  As a user, I want to securely log in and log out, ensuring my access token is properly managed and revoked.

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-19 @TC-JRN-01 @dryrun
  Scenario: Verify successful login, logout, and subsequent token revocation
    # This scenario covers TC1, TC6, and TC9 as a user journey.
    # TC1: Login with valid credentials from a pre-existing account.
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "Login successful"
    And I save "data.access_token" from the response as "accessToken"
    # TC6: Logout with the valid token.
    Given I have the following headers:
      | Authorization | Bearer {{accessToken}} |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 200
    And the response field "message" should be "Logged out successfully"
    # TC9: Attempt to use the now-revoked token.
    Given I have the following headers:
      | Authorization | Bearer {{accessToken}} |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Token has been revoked"

  @TS-TEST-19 @TC-TEST-19-02
  Scenario: Verify login fails with missing required fields
    # This scenario covers TC2.
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-19 @TC-TEST-19-03
  Scenario: Verify login fails with invalid email format
    # This scenario covers TC3.
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-19 @TC-TEST-19-04
  Scenario: Verify login fails with an incorrect password
    # This scenario covers TC4.
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-19 @TC-TEST-19-05
  Scenario: Verify login fails with malformed JSON
    # This scenario covers TC5.
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 400

  @TS-TEST-19 @TC-TEST-19-07
  Scenario: Verify logout fails with missing authorization header
    # This scenario covers TC7.
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Could not validate credentials"

  @TS-TEST-19 @TC-TEST-19-08
  Scenario: Verify logout fails with an invalid authorization token
    # This scenario covers TC8.
    Given I have the following headers:
      | Authorization | Bearer invalid.token.string |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Could not validate credentials"
