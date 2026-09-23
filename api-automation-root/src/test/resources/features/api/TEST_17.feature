Feature: Test Login API
  As a user, I want to authenticate with the system to access protected resources.

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-17 @TC-LOGIN-001 @dryrun
  Scenario: Verify successful login with valid credentials
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "Login successful"
    And the response field "data.token_type" should be "bearer"
    And the response field "data.access_token" should not be null

  @TS-TEST-17 @TC-LOGIN-002
  Scenario: Verify login failure with incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"
    And the response field "status_code" should be "401"

  @TS-TEST-17 @TC-LOGIN-003
  Scenario: Verify login failure with unregistered email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"
    And the response field "status_code" should be "401"

  @TS-TEST-17 @TC-LOGIN-004
  Scenario: Verify validation error for missing email field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "message" should be "Validation failed"

  @TS-TEST-17 @TC-LOGIN-005
  Scenario: Verify validation error for missing password field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "message" should be "Validation failed"

  @TS-TEST-17 @TC-LOGIN-006
  Scenario: Verify validation error for empty email string
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "message" should be "Validation failed"

  @TS-TEST-17 @TC-LOGIN-007
  Scenario: Verify validation error for empty password string
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "message" should be "Validation failed"

  @TS-TEST-17 @TC-LOGIN-008
  Scenario: Verify validation error for invalid email format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "message" should be "Validation failed"

  @TS-TEST-17 @TC-LOGIN-009
  Scenario: Verify API error for malformed JSON request body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-17 @TC-LOGIN-010
  Scenario: Verify validation error for empty JSON object body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "message" should be "Validation failed"

  @TS-TEST-17 @TC-LOGIN-011
  Scenario: Verify validation error for null request body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
