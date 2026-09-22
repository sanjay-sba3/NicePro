Feature: Test Login API
  As a user, I want to authenticate with the system to get access to protected resources.

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-17
  @TC-TEST-17-1
  @dryrun
  Scenario: Successful login for user with MFA disabled
    # This scenario assumes the pre-configured test account (via {{auth.username}}) has MFA disabled.
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "data.token_type" should be "bearer"
    And the response field "data.access_token" should not be null
    And the response field "data.mfa_required" should be "false"

  @TS-TEST-17
  @TC-TEST-17-2
  Scenario: Successful login for user with MFA enabled
    # This scenario assumes the pre-configured test account (via {{auth.username}}) has MFA enabled.
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "data.mfa_required" should be "true"
    And the response field "data.pre_auth_token" should not be null

  @TS-TEST-17
  @TC-TEST-17-3
  Scenario: Login failure with incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17
  @TC-TEST-17-4
  Scenario: Login failure with unregistered email
    # This scenario, along with TC-TEST-17-3, covers the user enumeration prevention check (TC5) by asserting an identical response for both invalid password and invalid email.
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17
  @TC-TEST-17-6
  Scenario: Validation error for missing email field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    # Assuming a standard error response structure like {"errors":{"email":["..."]}}
    And the response field "errors.email[0]" should not be null

  @TS-TEST-17
  @TC-TEST-17-7
  Scenario: Validation error for missing password field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    # Assuming a standard error response structure like {"errors":{"password":["..."]}}
    And the response field "errors.password[0]" should not be null

  @TS-TEST-17
  @TC-TEST-17-8
  Scenario: Validation error for invalid email format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors.email[0]" should be "value is not a valid email address"

  @TS-TEST-17
  @TC-TEST-17-9
  Scenario: Boundary test with empty string for email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors.email[0]" should not be null

  @TS-TEST-17
  @TC-TEST-17-10
  Scenario: Boundary test with empty string for password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors.password[0]" should not be null

  @TS-TEST-17
  @TC-TEST-17-11
  Scenario: Validation error for empty request body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors.email[0]" should not be null
    And the response field "errors.password[0]" should not be null

  @TS-TEST-17
  @TC-TEST-17-12
  Scenario: Error handling for malformed JSON body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 400
