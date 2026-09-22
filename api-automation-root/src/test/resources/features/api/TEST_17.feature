Feature: TEST-17 - Test Login API

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-17 @TC-TEST-17-01 @dryrun
  Scenario: TC1: Successful login for user with MFA disabled
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "data.token_type" should be "bearer"
    And the response field "data.access_token" should not be null
    And the response field "data.mfa_required" should be "false"

  @TS-TEST-17 @TC-TEST-17-02
  Scenario: TC2: Successful login for user with MFA enabled
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "data.mfa_required" should be "true"
    And the response field "data.pre_auth_token" should not be null
    And the response field "data.access_token" should be null

  @TS-TEST-17 @TC-TEST-17-03
  Scenario: TC3: Login failure with incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "status_code" should be "401"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17 @TC-TEST-17-04
  Scenario: TC4: Login failure with unregistered email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "status_code" should be "401"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17 @TC-TEST-17-06
  Scenario: TC6: Validation error for missing email field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    # Assuming error structure is {"errors":{"email":["error message"]}}
    And the response field "errors.email[0]" should not be null

  @TS-TEST-17 @TC-TEST-17-07
  Scenario: TC7: Validation error for missing password field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    # Assuming error structure is {"errors":{"password":["error message"]}}
    And the response field "errors.password[0]" should not be null

  @TS-TEST-17 @TC-TEST-17-08
  Scenario: TC8: Validation error for invalid email format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors.email[0]" should be "value is not a valid email address"

  @TS-TEST-17 @TC-TEST-17-09
  Scenario: TC9: Boundary test with empty string for email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors.email[0]" should not be null

  @TS-TEST-17 @TC-TEST-17-10
  Scenario: TC10: Boundary test with empty string for password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors.password[0]" should not be null

  @TS-TEST-17 @TC-TEST-17-11
  Scenario: TC11: Validation error for empty request body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors.email[0]" should not be null
    And the response field "errors.password[0]" should not be null

  @TS-TEST-17 @TC-TEST-17-12
  Scenario: TC12: Error handling for malformed JSON body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 400
