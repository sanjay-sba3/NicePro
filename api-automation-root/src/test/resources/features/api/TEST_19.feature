Feature: Test Logout and Token Revocation API

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-19
  @TC-TEST-19-9 # Primary TC-ID for this journey. Also covers TC-TEST-19-13 and TC-TEST-19-14.
  @dryrun
  Scenario: Successful logout revokes token which cannot be reused
    # Step 1: Login to get a token using the default credentials
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "data.access_token" should not be null
    And I save "data.access_token" from the response as "accessToken"
    
    # Step 2: Logout with the valid token (TC9)
    Given I have the following headers:
      | Authorization | Bearer {{accessToken}} |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 200
    And the response field "message" should be "Logged out successfully"
    
    # Step 3: Attempt to logout again with the same revoked token (TC13)
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Token has been revoked"
    
    # Step 4: Attempt to use the revoked token on a protected endpoint (TC14)
    # NOTE: The endpoint /api/v1/user/profile is hypothetical, based on the test case description.
    When I send a "GET" request to "/api/v1/user/profile"
    Then the response status code should be 401
    And the response field "message" should be "Token has been revoked"

  @TS-TEST-19
  @TC-TEST-19-1
  Scenario: Successful login with valid credentials
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "Login successful"
    And the response field "data.access_token" should not be null

  @TS-TEST-19
  @TC-TEST-19-2
  Scenario: Login attempt with missing email field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-19
  @TC-TEST-19-3
  Scenario: Login attempt with missing password field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-19
  @TC-TEST-19-4
  Scenario: Login attempt with invalid email format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-19
  @TC-TEST-19-5
  Scenario: Login attempt with empty JSON object body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-19
  @TC-TEST-19-6
  Scenario: Login attempt with a non-existent email address
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-19
  @TC-TEST-19-7
  Scenario: Login attempt with correct email and incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-19
  @TC-TEST-19-10
  Scenario: Logout attempt without Authorization header
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Could not validate credentials"

  @TS-TEST-19
  @TC-TEST-19-11
  Scenario: Logout attempt with an invalid token
    Given I have the following headers:
      | Authorization | Bearer this.is.not.a.valid.token |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Could not validate credentials"