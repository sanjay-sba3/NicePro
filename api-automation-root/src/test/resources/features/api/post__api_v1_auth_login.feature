Feature: Login API functionality
  As a user or client application
  I want to authenticate with the API
  So that I can access protected resources

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-17
  @TC-TEST-17-TC1
  @dryrun
  Scenario: Successful Login with MFA Disabled
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "data.access_token" should not be null
    And the response field "data.mfa_required" should be "false"
    And the response field "data.token_type" should be "bearer"
    And the response field "data.message" should be "Login successful"
    And the response field "status" should be "true"

  @TS-TEST-17
  @TC-TEST-17-TC2
  Scenario: Successful Login with MFA Enabled (Pre-Auth Token)
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "data.pre_auth_token" should not be null
    And the response field "data.mfa_required" should be "true"
    And the response field "data.token_type" should be "bearer"
    And the response field "data.message" should be "MFA verification required"
    And the response field "status" should be "true"

  @TS-TEST-17
  @TC-TEST-17-TC3
  Scenario: Login Failure - Missing Email Field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors[0].loc[1]" should be "email"
    And the response field "message" should be "Validation failed"
    And the response field "status" should be "false"

  @TS-TEST-17
  @TC-TEST-17-TC4
  Scenario: Login Failure - Missing Password Field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors[0].loc[1]" should be "password"
    And the response field "message" should be "Validation failed"
    And the response field "status" should be "false"

  @TS-TEST-17
  @TC-TEST-17-TC5
  Scenario: Login Failure - Invalid Email Format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors[0].loc[1]" should be "email"
    And the response field "errors[0].msg" should be "value is not a valid email address"
    And the response field "message" should be "Validation failed"
    And the response field "status" should be "false"

  @TS-TEST-17
  @TC-TEST-17-TC6
  Scenario: Login Failure - Incorrect Password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "message" should be "Invalid email or password"
    And the response field "status" should be "false"
    And the response field "status_code" should be "401"

  @TS-TEST-17
  @TC-TEST-17-TC7
  Scenario: Login Failure - Non-Existent Email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "message" should be "Invalid email or password"
    And the response field "status" should be "false"
    And the response field "status_code" should be "401"

  @TS-TEST-17
  @TC-TEST-17-TC8
  Scenario: Login Failure - Email as Non-String Type
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors[0].loc[1]" should be "email"
    And the response field "message" should be "Validation failed"
    And the response field "status" should be "false"

  @TS-TEST-17
  @TC-TEST-17-TC9
  Scenario: Login Failure - Password as Non-String Type
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors[0].loc[1]" should be "password"
    And the response field "message" should be "Validation failed"
    And the response field "status" should be "false"

  @TS-TEST-17
  @TC-TEST-17-TC10
  Scenario: Login Failure - Malformed JSON Request Body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be "400"

  @TS-TEST-17
  @TC-TEST-17-TC11
  Scenario: Login Failure - Empty JSON Object Request Body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors[0].loc[1]" should be "email"
    And the response field "errors[1].loc[1]" should be "password"
    And the response field "message" should be "Validation failed"
    And the response field "status" should be "false"

  @TS-TEST-17
  @TC-TEST-17-TC12
  Scenario: Login Failure - Null Request Body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be "400"

  @TS-TEST-17
  @TC-TEST-17-TC13
  Scenario: Login Failure - Missing Content-Type Header
    Given I remove the header "Content-Type"
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be "400"

  @TS-TEST-17
  @TC-TEST-17-TC14
  Scenario: Login Failure - Incorrect Content-Type Header
    Given I have the following headers:
      | Content-Type | text/plain |
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 415
