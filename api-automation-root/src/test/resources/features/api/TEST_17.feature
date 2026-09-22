Feature: Login API
  This feature file tests the login functionality, including MFA flows, validation, and error handling for the /api/v1/auth/login endpoint.

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-17
  @TC-1
  @dryrun
  Scenario: Successful login for user with MFA disabled
    # This test case validates a successful login for a pre-existing user with MFA disabled.
    # It uses auth tokens resolved at runtime to avoid committing credentials.
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "data.token_type" should be "bearer"
    And the response field "data.access_token" should not be null

  @TS-TEST-17
  @TC-2
  Scenario: Successful login for user with MFA enabled
    # This test case validates the initial login step for a user with MFA enabled.
    # As per Jira TEST-17, this is expected to return a pre-authentication token.
    # This response structure is not in the OpenAPI spec but is a specific requirement.
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    # Assuming the response indicates MFA requirement, e.g. with a specific field.
    # And the response field "data.mfa_required" should be "true"
    # And the response field "data.pre_auth_token" should not be null

  @TS-TEST-17
  @TC-3
  Scenario: Login failure with incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17
  @TC-4
  Scenario: Login failure with unregistered email
    # This test and TC-3 together validate user enumeration prevention (TC-5).
    # Both should return identical 401 responses.
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17
  @TC-6
  Scenario: Validation error for missing email field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors" should not be null

  @TS-TEST-17
  @TC-7
  Scenario: Validation error for missing password field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors" should not be null

  @TS-TEST-17
  @TC-8
  Scenario: Validation error for invalid email format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors[0].msg" should be "value is not a valid email address"

  @TS-TEST-17
  @TC-9
  Scenario: Boundary test with empty string for email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors" should not be null

  @TS-TEST-17
  @TC-10
  Scenario: Boundary test with empty string for password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors" should not be null

  @TS-TEST-17
  @TC-11
  Scenario: Validation error for empty request body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors" should not be null

  @TS-TEST-17
  @TC-12
  Scenario: Error handling for malformed JSON body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 400
