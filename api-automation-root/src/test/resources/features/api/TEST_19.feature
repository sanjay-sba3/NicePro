Feature: Test Logout and Token Revocation API
  Validate user authentication, logout functionality, and access token revocation.

  This feature covers test cases from Jira Story TEST-19.
  Note on TC-8 (User Enumeration): This is verified by scenarios TC-6 and TC-7.
  Both test different invalid login attempts (non-existent user, wrong password)
  and assert they result in the identical, generic 401 error response, fulfilling
  the requirement to prevent user enumeration.

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-19
  @TC-1
  Scenario: Successful login with valid credentials
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "Login successful"
    And the response field "data.access_token" should not be null

  @TS-TEST-19
  @TC-2
  Scenario: Login attempt with missing 'email' field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-19
  @TC-3
  Scenario: Login attempt with missing 'password' field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-19
  @TC-4
  Scenario: Login attempt with invalid email format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-19
  @TC-5
  Scenario: Login attempt with empty JSON object body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-19
  @TC-6
  Scenario: Login attempt with a non-existent email address
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-19
  @TC-7
  Scenario: Login attempt with correct email and incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-19
  @TC-9
  @dryrun
  Scenario: Successful login and logout journey
    # Step 1: Login with valid credentials
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And I save "data.access_token" from the response as "validAccessToken"

    # Step 2: Logout with the obtained valid token
    Given I have the following headers:
      | Authorization | Bearer {{validAccessToken}} |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "Logged out successfully"

  @TS-TEST-19
  @TC-10
  Scenario: Logout attempt without Authorization header
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Could not validate credentials"

  @TS-TEST-19
  @TC-11
  Scenario: Logout attempt with an invalid token
    Given I have the following headers:
      | Authorization | Bearer this.is.not.a.valid.token |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Could not validate credentials"

  @TS-TEST-19
  @TC-12
  Scenario: Logout attempt with an expired token
    # This scenario simulates using an expired token by using a structurally valid but non-existent token.
    Given I have the following headers:
      | Authorization | Bearer expired.token.value |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Could not validate credentials"

  @TS-TEST-19
  @TC-13
  Scenario: Logout attempt with an already revoked token
    # Step 1: Login to get a valid token
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And I save "data.access_token" from the response as "tokenToRevoke"

    # Step 2: Logout to revoke the token
    Given I have the following headers:
      | Authorization | Bearer {{tokenToRevoke}} |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 200

    # Step 3: Attempt to logout again with the same, now revoked, token
    Given I have the following headers:
      | Authorization | Bearer {{tokenToRevoke}} |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Token has been revoked"

  @TS-TEST-19
  @TC-14
  Scenario: Use a revoked token on a protected endpoint
    # Step 1: Login to get a valid token
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And I save "data.access_token" from the response as "tokenToRevokeAndUse"

    # Step 2: Logout to revoke the token
    Given I have the following headers:
      | Authorization | Bearer {{tokenToRevokeAndUse}} |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 200

    # Step 3: Attempt to use the revoked token on a protected endpoint
    Given I have the following headers:
      | Authorization | Bearer {{tokenToRevokeAndUse}} |
    When I send a "GET" request to "/api/v1/user/profile"
    Then the response status code should be 401
    And the response field "message" should be "Token has been revoked"
