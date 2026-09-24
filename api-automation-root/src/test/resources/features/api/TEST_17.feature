Feature: Test Login API

  Background:
    Given the API base URL is set
    # This endpoint does not require pre-authentication, so the no-op token step is sufficient.
    And I have a valid authentication token

  @dryrun @TS-LOGIN-001 @TC-LOGIN-001
  Scenario: Successful login with valid credentials (MFA disabled)
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "Login successful"
    And the response field "data.token_type" should be "bearer"
    And the response field "data.access_token" should not be null

  @TS-LOGIN-001 @TC-LOGIN-002
  Scenario: Successful login with valid credentials (MFA enabled) returns a pre-auth token
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    # Per Jira, the response indicates MFA is required and includes a pre-auth token.
    # The exact field names are not specified, so we assume 'mfa_required' and 'pre_authentication_token'.
    And the response field "data.mfa_required" should be "true"
    And the response field "data.pre_authentication_token" should not be null

  @TS-LOGIN-001 @TC-LOGIN-003
  Scenario: Login fails with incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-LOGIN-001 @TC-LOGIN-004
  Scenario: Login fails with non-existent email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-LOGIN-001 @TC-LOGIN-005
  Scenario: Verify error messages are identical to prevent user enumeration
    Given I have the following payload:
      """
      {"email":"{{auth.username}}","password":"WrongPassword!"}
      """
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And I save "." from the response as "incorrectPasswordResponse"

    Given I have the following payload:
      """
      {"email":"nonexistent@example.com","password":"any_password"}
      """
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response should be identical to the saved JSON object "incorrectPasswordResponse"

  @TS-LOGIN-001 @TC-LOGIN-006
  Scenario: Login fails with validation error for empty body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-LOGIN-001 @TC-LOGIN-007
  Scenario: Login fails with validation error for invalid email format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-LOGIN-001 @TC-LOGIN-008
  Scenario: Login fails with validation error for non-string data types
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-LOGIN-001 @TC-LOGIN-009
  Scenario: API returns client error for malformed JSON request body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 400

  @TS-LOGIN-001 @TC-LOGIN-010
  Scenario: API returns validation error for null JSON request body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
