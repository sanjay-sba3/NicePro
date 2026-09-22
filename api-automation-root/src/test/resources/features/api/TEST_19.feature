Feature: TEST-19 - Test Logout and Token Revocation API

  Validate logout functionality and access token revocation, including successful logout, invalid tokens, token blacklisting, and behavior when a revoked token is reused.

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS1
  @TC1
  @dryrun
  Scenario: TC1: Verify a user can successfully log out using a valid and active access token
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And I save "data.access_token" from the response as "accessToken"
    And I have the following headers:
      | Authorization | Bearer {{accessToken}} |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 200
    And the response field "message" should be "Logged out successfully"

  @TS2
  @TC2
  Scenario: TC2: Verify a previously revoked token cannot be used to access the logout endpoint again
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And I save "data.access_token" from the response as "revokedAccessToken"
    And I have the following headers:
      | Authorization | Bearer {{revokedAccessToken}} |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 200
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Token has been revoked"

  @TS3
  @TC3
  Scenario: TC3: Verify the logout endpoint returns a 401 error when no Authorization header is provided
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Could not validate credentials"

  @TS4
  @TC4
  Scenario: TC4: Verify the logout endpoint returns a 401 error when an invalid token is provided
    Given I have the following headers:
      | Authorization | Bearer invalid-token-string |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Could not validate credentials"

  @TS5
  @TC5
  Scenario: TC5: Verify the logout endpoint returns a 401 error when an expired access token is provided
    Given I have the following headers:
      | Authorization | Bearer {{auth.expired_token}} |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Could not validate credentials"

  @TS6
  @TC6
  @dryrun
  Scenario: TC6: Verify a user with MFA disabled can successfully log in with valid credentials
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "message" should be "Login successful"
    And the response field "data.mfa_required" should be "false"
    And the response field "data.access_token" should not be null

  @TS7
  @TC7
  Scenario: TC7: Verify a user with MFA enabled can successfully log in to obtain a pre-auth token
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "message" should be "MFA verification required"
    And the response field "data.mfa_required" should be "true"
    And the response field "data.pre_auth_token" should not be null

  @TS8
  @TC8
  Scenario: TC8: Verify login fails with a valid email but an incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "message" should be "Invalid email or password"

  @TS9
  @TC9
  Scenario: TC9: Verify login fails with a non-existent email address
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "message" should be "Invalid email or password"

  @TS10
  @TC10
  Scenario: TC10: Verify error messages are identical to prevent user enumeration
    Given I have the following payload:
      """
      {"email":"{{auth.username}}","password":"IncorrectPassword"}
      """
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And I save "message" from the response as "firstErrorMessage"
    Given I have the following payload:
      """
      {"email":"no-such-user@example.com","password":"any-password"}
      """
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "message" should be "{{firstErrorMessage}}"

  @TS11
  @TC11
  Scenario: TC11: Verify login fails with a missing email field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS12
  @TC12
  Scenario: TC12: Verify login fails with a missing password field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS13
  @TC13
  Scenario: TC13: Verify login fails with an invalid email format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS14
  @TC14
  Scenario: TC14: Verify login fails with a malformed JSON body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS15
  @TC15
  Scenario: TC15: Verify login fails with an empty JSON object body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
