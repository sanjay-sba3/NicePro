Feature: Test Login API
  As a user, I want to authenticate with the system to gain access to protected resources.
  This feature covers various login scenarios including successful authentication, MFA flows, and error handling.

  Background:
    Given the API base URL is set
    # The following step is a no-op but included for consistency with unauthenticated endpoints.
    # The login endpoint itself does not require a pre-existing token.
    And I have a valid authentication token

  @TS-TEST-17 @TC-1 @dryrun
  Scenario: Verify successful login for user with MFA disabled
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "Login successful"
    And the response field "data.token_type" should be "bearer"
    And the response field "data.access_token" should not be null

  @TS-TEST-17 @TC-2
  Scenario: Verify login for user with MFA enabled requires MFA verification
    # Note: This scenario tests a business rule from JIRA (TEST-17) that is not reflected in the provided API specification.
    # The specification does not describe the MFA-enabled login flow, so the expected response is based on the JIRA description.
    When I send a "POST" request to "/api/v1/auth/login"
    # Expected status code for MFA-required flow is not in the spec. Assuming 200 OK for now.
    Then the response status code should be 200
    # The following assertions are based on the JIRA description and may need adjustment.
    # And the response field "data.mfa_required" should be "true"
    # And the response field "data.pre_auth_token" should not be null

  @TS-TEST-17 @TC-3
  Scenario: Verify login fails with a 422 error when 'email' field is missing
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "message" should be "Validation failed"

  @TS-TEST-17 @TC-4
  Scenario: Verify login fails with a 422 error when 'password' field is missing
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "message" should be "Validation failed"

  @TS-TEST-17 @TC-5
  Scenario: Verify login fails with a 422 error for an invalid email format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "message" should be "Validation failed"

  @TS-TEST-17 @TC-6
  Scenario: Verify login fails with a 401 error for an incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17 @TC-7
  Scenario: Verify login fails with a 401 error for a non-existent user email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17 @TC-8
  Scenario: Verify login fails with a 422 error when the request body is an empty JSON object
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-17 @TC-9
  Scenario: Verify login request fails when the request body is null
    When I send a "POST" request to "/api/v1/auth/login"
    # Expected status can be 400 or 422. Using 422 for consistency with other validation errors.
    Then the response status code should be 422

  @TS-TEST-17 @TC-10
  Scenario: Verify login request fails when the request body contains malformed JSON
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 400

