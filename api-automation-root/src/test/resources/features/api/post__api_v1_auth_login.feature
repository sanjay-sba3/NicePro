Feature: Test Login API
  Validate the login API for accounts with and without MFA, and handle various invalid inputs.

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-17 @TC-LOGIN-001 @dryrun
  Scenario: Successful login for user with MFA disabled
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "Login successful"
    And the response field "data.token_type" should be "bearer"
    And the response field "data.access_token" should not be null

  @TS-TEST-17 @TC-LOGIN-002
  Scenario: Successful login first step for user with MFA enabled
    # This scenario assumes the MFA-enabled response contains a message and a pre-auth token as described.
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "message" should be "MFA verification required"
    And the response field "data.pre_auth_token" should not be null
    And the response field "data.access_token" should be null

  @TS-TEST-17 @TC-LOGIN-003
  Scenario: Validate successful login response structure for MFA-disabled user
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should not be null
    And the response field "message" should not be null
    And the response field "status_code" should be "200"
    And the response field "data" should not be null
    And the response field "data.message" should not be null
    And the response field "data.token_type" should be "bearer"
    And the response field "data.access_token" should not be null

  @TS-TEST-17 @TC-LOGIN-004
  Scenario: Login attempt with incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "status_code" should be "401"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17 @TC-LOGIN-005
  Scenario: Login attempt with non-existent email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "status_code" should be "401"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17 @TC-LOGIN-006
  Scenario: Verify ambiguous 401 error to prevent user enumeration
    # First call with an invalid password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And I save "." from the response as "responseInvalidPassword"
    # Second call with a non-existent user, using an explicit payload
    Given I have the following payload:
    """
    {
      "email": "nonexistent-user@example.com",
      "password": "any-password"
    }
    """
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And I save "." from the response as "responseNonExistentUser"
    # Compare the two full response bodies
    And the saved context value "responseInvalidPassword" should be equal to the saved context value "responseNonExistentUser"

  @TS-TEST-17 @TC-LOGIN-007
  Scenario: Login attempt with missing email field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-17 @TC-LOGIN-008
  Scenario: Login attempt with missing password field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-17 @TC-LOGIN-009
  Scenario: Login attempt with invalid email format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-17 @TC-LOGIN-010
  Scenario: Login attempt with empty string for email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-17 @TC-LOGIN-011
  Scenario: Login attempt with empty string for password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-17 @TC-LOGIN-012
  Scenario: Login attempt with empty JSON object
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-17 @TC-LOGIN-013
  Scenario: Login attempt with malformed JSON body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 400

  @TS-TEST-17 @TC-LOGIN-014
  Scenario: Login attempt with null request body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
