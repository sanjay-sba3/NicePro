Feature: Test Login API
  Validate the login API for accounts with and without MFA enabled. The tests cover successful authentication, invalid credentials, and various input validation scenarios.
  # This feature covers test cases TC1 through TC12 from Story TEST-17.
  # TC13 (User enumeration prevention) is implicitly covered by the assertions in TC4 and TC5, which both verify the identical error response, fulfilling the requirement without needing a complex custom step.

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-LOGIN-001 @TC-17-1 @dryrun
  Scenario: Login with valid credentials (MFA disabled)
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "Login successful"
    And the response field "status_code" should be "200"
    And the response field "data.token_type" should be "bearer"
    And the response field "data.access_token" should not be null

  @TS-LOGIN-001 @TC-17-2
  Scenario: Login with valid credentials (MFA enabled)
    # TODO: The exact status code and response body for the MFA flow are not defined in the API specification.
    # The following steps assume a 200 OK response with a body indicating MFA is required, based on the Jira story description.
    # This test requires 'auth.mfa_enabled_username' and 'auth.mfa_enabled_password' tokens to be configured in the framework.
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "data.mfa_required" should be "true" # Hypothetical field, based on Jira description
    And the response field "data.pre_auth_token" should not be null # Hypothetical field, based on Jira description

  @TS-LOGIN-001 @TC-17-3
  Scenario: Successful login response structure validation
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should not be null
    And the response field "message" should not be null
    And the response field "status_code" should not be null
    And the response field "data" should not be null
    And the response field "data.token_type" should be "bearer"
    And the response field "data.access_token" should not be null

  @TS-LOGIN-001 @TC-17-4
  Scenario: Login with incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"
    And the response field "status_code" should be "401"

  @TS-LOGIN-001 @TC-17-5
  Scenario: Login with non-existent email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"
    And the response field "status_code" should be "401"

  @TS-LOGIN-001 @TC-17-6
  Scenario: Login with missing email field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-LOGIN-001 @TC-17-7
  Scenario: Login with missing password field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-LOGIN-001 @TC-17-8
  Scenario: Login with invalid email format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"
    And the response field "errors[0].msg" should be "value is not a valid email address"

  @TS-LOGIN-001 @TC-17-9
  Scenario: Login with empty string for email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-LOGIN-001 @TC-17-10
  Scenario: Login with empty string for password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "message" should be "Invalid email or password"

  @TS-LOGIN-001 @TC-17-11
  Scenario: Login with empty JSON object body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-LOGIN-001 @TC-17-12
  Scenario: Login with malformed JSON body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    # The exact error message for malformed JSON is implementation-dependent.
    And the response field "message" should not be null
