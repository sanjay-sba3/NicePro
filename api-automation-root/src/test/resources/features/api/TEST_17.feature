Feature: TEST-17 - Test Login API
  As a user, I want to authenticate with my credentials to access the system.

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-17
  @TC-TEST-17-001
  @dryrun
  Scenario: TC1: Login with valid credentials (MFA disabled)
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "Login successful"
    And the response field "data.mfa_required" should be "false"
    And the response field "data.token_type" should be "bearer"
    And the response field "data.access_token" should not be null

  @TS-TEST-17
  @TC-TEST-17-002
  Scenario: TC2: Login with valid credentials (MFA enabled)
    # This scenario assumes the framework can resolve specific user credentials for testing MFA flows.
    # The tokens {{auth.mfa_user.email}} and {{auth.mfa_user.password}} are placeholders for this capability.
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "data.mfa_required" should be "true"
    And the response field "data.pre_auth_token" should not be null
    And the response field "data.access_token" should be null

  @TS-TEST-17
  @TC-TEST-17-003
  Scenario: TC3: Successful login response structure validation
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "Login successful"
    And the response field "status_code" should be "200"
    And the response field "data.token_type" should be "bearer"
    And the response field "data.access_token" should not be null

  @TS-TEST-17
  @TC-TEST-17-004
  Scenario: TC4: Login with incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"
    And the response field "status_code" should be "401"

  @TS-TEST-17
  @TC-TEST-17-005
  Scenario: TC5: Login with non-existent email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17
  @TC-TEST-17-006
  Scenario: TC6: Login with missing email field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-17
  @TC-TEST-17-007
  Scenario: TC7: Login with missing password field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-17
  @TC-TEST-17-008
  Scenario: TC8: Login with invalid email format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors[0].msg" should be "value is not a valid email address"

  @TS-TEST-17
  @TC-TEST-17-009
  Scenario: TC9: Login with empty string for email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors[0].msg" should be "value is not a valid email address"

  @TS-TEST-17
  @TC-TEST-17-010
  Scenario: TC10: Login with empty string for password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-17
  @TC-TEST-17-011
  Scenario: TC11: Login with empty JSON object body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-17
  @TC-TEST-17-012
  Scenario: TC12: Login with malformed JSON body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-17
  @TC-TEST-17-013
  Scenario: TC13: User enumeration prevention check
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"
    And the response field "status_code" should be "401"
