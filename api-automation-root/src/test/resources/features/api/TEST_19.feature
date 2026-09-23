Feature: Test Logout and Token Revocation API
  Validate logout functionality and access token revocation, including handling of invalid and revoked tokens.

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-19
  @TC-1
  Scenario: TC-1: Successful login with valid credentials
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "Login successful"
    And the response field "data.access_token" should not be null

  @TS-TEST-19
  @TC-2
  Scenario: TC-2: Login fails with missing email and password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-19
  @TC-3
  Scenario: TC-3: Login fails with invalid email format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-19
  @TC-4
  Scenario: TC-4: Login fails with incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-19
  @TC-5
  Scenario: TC-5: Login fails with malformed JSON
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 400

  @TS-TEST-19
  @TC-6
  Scenario: TC-6: Successful logout with a valid token
    # Step 1: Log in to get a valid token
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And I save "data.access_token" from the response as "accessToken"
    
    # Step 2: Use the token to log out
    Given I have the following headers:
      | Authorization | Bearer {{accessToken}} |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "Logged out successfully"

  @TS-TEST-19
  @TC-7
  Scenario: TC-7: Logout fails with a missing authorization header
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Could not validate credentials"

  @TS-TEST-19
  @TC-8
  Scenario: TC-8: Logout fails with an invalid authorization token
    Given I have the following headers:
      | Authorization | Bearer invalid.token.string |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Could not validate credentials"

  @TS-TEST-19
  @TC-9
  @dryrun
  Scenario: TC-9: Attempting to use a revoked token fails
    # Step 1: Log in to get a valid token
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And I save "data.access_token" from the response as "revokedAccessToken"

    # Step 2: Use the token to log out, which revokes it
    Given I have the following headers:
      | Authorization | Bearer {{revokedAccessToken}} |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 200

    # Step 3: Attempt to use the same, now-revoked token again
    Given I have the following headers:
      | Authorization | Bearer {{revokedAccessToken}} |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Token has been revoked"
