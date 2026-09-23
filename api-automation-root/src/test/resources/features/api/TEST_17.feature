Feature: Test Login API
  Validate the login API for accounts with and without MFA, including positive, negative, and boundary test cases.

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-17
  @TC-TC1
  @dryrun
  Scenario: Verify successful login with valid credentials and MFA disabled
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "Login successful"
    And the response field "data.token_type" should be "bearer"
    And the response field "data.access_token" should not be null

  @TS-TEST-17
  @TC-TC2
  Scenario: Verify login response for a user with MFA enabled
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    # TODO: The exact response structure for MFA enabled login is described in Jira but not in the API Spec.
    # Assuming a response shape based on Jira description for this test.
    And the response field "data.message" should be "MFA verification is required"
    And the response field "data.pre-authentication_token" should not be null

  @TS-TEST-17
  @TC-TC3
  Scenario: Verify login failure with incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17
  @TC-TC4
  Scenario: Verify login failure with non-existent email for user enumeration prevention
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17
  @TC-TC5
  Scenario: Verify 422 validation error for missing 'email' field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "message" should be "Validation failed"

  @TS-TEST-17
  @TC-TC6
  Scenario: Verify 422 validation error for missing 'password' field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "message" should be "Validation failed"

  @TS-TEST-17
  @TC-TC7
  Scenario: Verify 422 validation error for invalid email format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "message" should be "Validation failed"

  @TS-TEST-17
  @TC-TC8
  Scenario: Verify 422 validation error for empty 'email' field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "message" should be "Validation failed"

  @TS-TEST-17
  @TC-TC9
  Scenario: Verify 422 validation error for empty 'password' field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "message" should be "Validation failed"

  @TS-TEST-17
  @TC-TC10
  Scenario: Verify 422 validation error for empty JSON object body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "message" should be "Validation failed"

  @TS-TEST-17
  @TC-TC11
  Scenario: Verify client error for malformed JSON body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 400
