Feature: Test Login API

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-17 @TC-1 @dryrun
  Scenario: Successful login for a user with MFA disabled
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "data.mfa_required" should be "false"
    And the response field "data.access_token" should not be null

  @TS-TEST-17 @TC-2
  Scenario: Successful login attempt for a user with MFA enabled
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "data.mfa_required" should be "true"
    And the response field "data.challenge_token" should not be null

  @TS-TEST-17 @TC-3
  Scenario: Login fails with incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "message" should be "Invalid credentials, the account is not active, or its organization is archived."

  @TS-TEST-17 @TC-4
  Scenario: Login fails for an archived user account
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "message" should be "Invalid credentials, the account is not active, or its organization is archived."

  @TS-TEST-17 @TC-5
  Scenario: Login fails with an empty JSON object in the request body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors.username_or_email" should be "Field required"

  @TS-TEST-17 @TC-6
  Scenario: Login fails when the 'username_or_email' field is missing from the request body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors.username_or_email" should be "Field required"

  @TS-TEST-17 @TC-7
  Scenario: Login fails when the 'password' field is an empty string
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-17 @TC-8
  Scenario: Login fails with a syntactically invalid email format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-17 @TC-9
  Scenario: Verify rate limiting is triggered after multiple failed login attempts
    When I send a "POST" request to "/api/v1/auth/login" 6 times
    Then the response status code should be 429
    And the response field "message" should be "Too many login attempts from this IP — blocked for 5 minutes."

  @TS-TEST-17 @TC-10
  Scenario: Verify login endpoint is not vulnerable to SQL injection in the email field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
