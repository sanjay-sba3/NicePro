Feature: Test Login API
  Validate the login API for accounts with MFA disabled and MFA enabled, including positive, negative, and boundary test cases.

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-17 @TC-TEST-17-01 @dryrun
  Scenario: TC1: Verify successful login with MFA disabled
    # This scenario assumes the default credentials configured in auth_credentials.properties or SuiteAuthContext belong to a user with MFA disabled.
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "data.message" should be "Login successful"
    And the response field "data.mfa_required" should be "false"
    And the response field "data.access_token" should not be null

  @TS-TEST-17 @TC-TEST-17-02
  Scenario: TC2: Verify successful login with MFA enabled
    # This scenario requires a pre-configured user with MFA enabled.
    # The placeholders {{mfa.enabled.username}} and {{mfa.enabled.password}} are used in testdata.
    # These must be resolved by a custom configuration or framework extension as they are not standard.
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "data.message" should be "MFA verification required"
    And the response field "data.mfa_required" should be "true"
    And the response field "data.pre_auth_token" should not be null

  @TS-TEST-17 @TC-TEST-17-03
  Scenario: TC3: Verify error for incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17 @TC-TEST-17-04
  Scenario: TC4: Verify error for non-existent email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17 @TC-TEST-17-05
  Scenario: TC5: Verify validation error for missing email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-17 @TC-TEST-17-06
  Scenario: TC6: Verify validation error for missing password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-17 @TC-TEST-17-07
  Scenario: TC7: Verify validation error for invalid email format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-17 @TC-TEST-17-08
  Scenario: TC8: Verify validation error for empty email string
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-17 @TC-TEST-17-09
  Scenario: TC9: Verify validation error for empty password string
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-17 @TC-TEST-17-10
  Scenario: TC10: Verify validation error for null email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-17 @TC-TEST-17-11
  Scenario: TC11: Verify validation error for null password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-17 @TC-TEST-17-12
  Scenario: TC12: Verify validation error for empty JSON object body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-17 @TC-TEST-17-13
  Scenario: TC13: Verify client error for malformed JSON body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 400

  @TS-TEST-17 @TC-TEST-17-14
  Scenario: TC14: Verify user enumeration is prevented with identical error responses
    # This scenario makes two separate API calls to ensure the error response is identical for different failure reasons.
    # First call with an invalid password (auto-resolved from TC tag).
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"
    And the response field "status_code" should be "401"

    # Second call with a non-existent user (payload specified explicitly).
    Given I have the following payload:
      """
      {
        "email": "{{random.email}}",
        "password": "anyPassword"
      }
      """
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"
    And the response field "status_code" should be "401"
