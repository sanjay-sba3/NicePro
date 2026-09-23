Feature: Test Login API
  Validate the login API for accounts with MFA disabled and MFA enabled, and handle various error conditions.

  Background:
    Given the API base URL is set
    And I have a valid authentication token

@TS-TEST-17 @TC-TEST-17-01 @dryrun
Scenario: Successful login for user with MFA disabled
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 200
  And the response should match the response schema "post__api_v1_auth_login_200_mfa_disabled_response_schema.json"
  And the response field "status" should be "true"
  And the response field "message" should be "Login successful"
  And the response field "data.token_type" should be "bearer"
  And the response field "data.access_token" should not be null

@TS-TEST-17 @TC-TEST-17-02
Scenario: Successful login first step for user with MFA enabled
  # This test assumes a separate user account with MFA enabled is configured in the test environment.
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 200
  And the response should match the response schema "post__api_v1_auth_login_200_mfa_enabled_response_schema.json"
  # The assertions below validate the MFA-required response structure as described in the Jira story.
  And the response field "data.mfa_required" should be "true"
  And the response field "data.pre_auth_token" should not be null

@TS-TEST-17 @TC-TEST-17-04
Scenario: Login attempt with incorrect password
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 401
  And the response field "status" should be "false"
  And the response field "message" should be "Invalid email or password"

@TS-TEST-17 @TC-TEST-17-05
Scenario: Login attempt with non-existent email
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 401
  And the response field "status" should be "false"
  And the response field "message" should be "Invalid email or password"

@TS-TEST-17 @TC-TEST-17-06
Scenario: Verify ambiguous 401 error to prevent user enumeration
  # First call with invalid password
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 401
  And the response field "message" should be "Invalid email or password"
  And I save "message" from the response as "invalidPasswordMessage"

  # Second call with non-existent user, using an explicit payload to override the TC-ID data for this call
  Given I have the following payload:
  """
  {
    "email": "nonexistent-user-for-tc6@example.com",
    "password": "any-password"
  }
  """
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 401
  And the response field "message" should be "{{invalidPasswordMessage}}"

@TS-TEST-17 @TC-TEST-17-07
Scenario: Login attempt with missing email field
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "message" should be "Validation failed"
  And the response field "errors[0].msg" should be "field required"

@TS-TEST-17 @TC-TEST-17-08
Scenario: Login attempt with missing password field
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "message" should be "Validation failed"
  And the response field "errors[0].msg" should be "field required"

@TS-TEST-17 @TC-TEST-17-09
Scenario: Login attempt with invalid email format
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "message" should be "Validation failed"
  And the response field "errors[0].msg" should be "value is not a valid email address"

@TS-TEST-17 @TC-TEST-17-10
Scenario: Login attempt with empty string for email
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "message" should be "Validation failed"

@TS-TEST-17 @TC-TEST-17-11
Scenario: Login attempt with empty string for password
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "message" should be "Validation failed"

@TS-TEST-17 @TC-TEST-17-12
Scenario: Login attempt with empty JSON object
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "message" should be "Validation failed"

@TS-TEST-17 @TC-TEST-17-13
Scenario: Login attempt with malformed JSON body
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422

@TS-TEST-17 @TC-TEST-17-14
Scenario: Login attempt with null request body
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
