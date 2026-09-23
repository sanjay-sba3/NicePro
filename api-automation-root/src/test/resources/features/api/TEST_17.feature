Feature: Test Login API
  Validate the login API for accounts with and without MFA, and handle various invalid inputs.

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST17-001
  @TC-TEST17-001
  @dryrun
  Scenario: TC1: Login with valid credentials and MFA disabled
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "Login successful"
    And the response field "data.token_type" should be "bearer"
    And the response field "data.access_token" should not be null

  @TS-TEST17-001
  @TC-TEST17-002
  Scenario: TC2: Login with valid credentials and MFA enabled
    # This scenario assumes the API returns a 200 OK with a specific MFA-required payload,
    # as described in Jira TEST-17, which is not detailed in the OpenAPI spec.
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response should indicate MFA is required

  @TS-TEST17-001
  @TC-TEST17-003
  Scenario: TC3: Login attempt with incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"
    And the response field "status_code" should be "401"

  @TS-TEST17-001
  @TC-TEST17-004
  Scenario: TC4: Login attempt with non-existent email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"
    And the response field "status_code" should be "401"

  @TS-TEST17-001
  @TC-TEST17-005
  Scenario: TC5: Login with missing 'email' field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors[0].loc[1]" should be "email"

  @TS-TEST17-001
  @TC-TEST17-006
  Scenario: TC6: Login with missing 'password' field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors[0].loc[1]" should be "password"

  @TS-TEST17-001
  @TC-TEST17-007
  Scenario: TC7: Login with empty string for 'email'
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors[0].msg" should be "value is not a valid email address"

  @TS-TEST17-001
  @TC-TEST17-008
  Scenario: TC8: Login with empty string for 'password'
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST17-001
  @TC-TEST17-009
  Scenario: TC9: Login with invalid email format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors[0].msg" should be "value is not a valid email address"

  @TS-TEST17-001
  @TC-TEST17-010
  Scenario: TC10: Login with null value for 'email'
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST17-001
  @TC-TEST17-011
  Scenario: TC11: Login with null value for 'password'
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST17-001
  @TC-TEST17-012
  Scenario: TC12: Login with an empty JSON object body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST17-001
  @TC-TEST17-013
  Scenario: TC13: Login with malformed JSON body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 400

  @TS-TEST17-001
  @TC-TEST17-014
  Scenario: TC14: Login with extra fields in request body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "data.access_token" should not be null

  @TS-TEST17-001
  @TC-TEST17-015
  Scenario: TC15: Verify 200 OK response structure for successful login
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should not be null
    And the response field "message" should not be null
    And the response field "status_code" should be "200"
    And the response field "data.message" should not be null
    And the response field "data.token_type" should be "bearer"
    And the response field "data.access_token" should not be null

  @TS-TEST17-001
  @TC-TEST17-016
  Scenario: TC16: Verify 401 Unauthorized response structure
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"
    And the response field "status_code" should be "401"

  @TS-TEST17-001
  @TC-TEST17-017
  Scenario: TC17: Verify 422 Unprocessable Entity response structure
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "message" should be "Validation failed"
    And the response field "status_code" should be "422"
    And the response field "errors" should not be null
    And the response field "errors[0].loc" should not be null
    And the response field "errors[0].msg" should not be null
    And the response field "errors[0].type" should not be null
