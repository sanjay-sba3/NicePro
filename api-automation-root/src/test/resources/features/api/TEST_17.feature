Feature: Test Login API

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-17
  @TC-TEST-17-1
  Scenario: Login Failure - User with MFA Disabled
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17
  @TC-TEST-17-2
  @dryrun
  Scenario: Successful Login with MFA Enabled
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "MFA verification required"
    And the response field "data.mfa_required" should be "true"
    And the response field "data.token_type" should be "bearer"
    And the response field "data.pre_auth_token" should not be null

  @TS-TEST-17
  @TC-TEST-17-3
  Scenario: Login Failure - Missing Email Field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors.email" should not be null

  @TS-TEST-17
  @TC-TEST-17-4
  Scenario: Login Failure - Missing Password Field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors.password" should not be null

  @TS-TEST-17
  @TC-TEST-17-5
  Scenario: Login Failure - Invalid Email Format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors.email" should not be null

  @TS-TEST-17
  @TC-TEST-17-6
  Scenario: Login Failure - Incorrect Password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17
  @TC-TEST-17-7
  Scenario: Login Failure - Non-Existent Email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17
  @TC-TEST-17-8
  Scenario: Login Failure - Email as Non-String Type
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors.email" should not be null

  @TS-TEST-17
  @TC-TEST-17-9
  Scenario: Login Failure - Password as Non-String Type
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors.password" should not be null

  @TS-TEST-17
  @TC-TEST-17-10
  Scenario: Login Failure - Malformed JSON Request Body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 400

  @TS-TEST-17
  @TC-TEST-17-11
  Scenario: Login Failure - Empty JSON Object Request Body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors.email" should not be null
    And the response field "errors.password" should not be null

  @TS-TEST-17
  @TC-TEST-17-12
  Scenario: Login Failure - Null Request Body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 400

  @TS-TEST-17
  @TC-TEST-17-13
  Scenario: Login Failure - Missing Content-Type Header
    Given I remove the "Content-Type" header
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 415

  @TS-TEST-17
  @TC-TEST-17-14
  Scenario: Login Failure - Incorrect Content-Type Header
    Given I have the following headers:
      | Content-Type | text/plain |
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 415
