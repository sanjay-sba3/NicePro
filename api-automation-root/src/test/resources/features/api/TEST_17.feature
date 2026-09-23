Feature: Test Login API

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-17 @TC-TEST-17-1 @dryrun
  Scenario: TC1: Successful login for user with MFA disabled
    Given I have the following payload:
    """
    {
      "email": "{{auth.username}}",
      "password": "{{auth.password}}"
    }
    """
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "Login successful"
    And the response field "data.token_type" should be "bearer"
    And the response field "data.access_token" should not be null

  @TS-TEST-17 @TC-TEST-17-2
  Scenario: TC2: Successful initial login for user with MFA enabled
    Given I have the following payload:
    """
    {
      "email": "{{auth.username}}",
      "password": "{{auth.password}}"
    }
    """
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response should indicate MFA is required and include a pre-authentication token

  @TS-TEST-17 @TC-TEST-17-3
  Scenario: TC3: Login attempt with valid email and incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17 @TC-TEST-17-4
  Scenario: TC4: Login attempt with a non-existent email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-17 @TC-TEST-17-5
  Scenario: TC5: Login attempt with missing 'email' field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response body should contain "email"

  @TS-TEST-17 @TC-TEST-17-6
  Scenario: TC6: Login attempt with missing 'password' field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response body should contain "password"

  @TS-TEST-17 @TC-TEST-17-7
  Scenario: TC7: Login attempt with a null value for 'email'
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response body should contain "email"

  @TS-TEST-17 @TC-TEST-17-8
  Scenario: TC8: Login attempt with an empty string for 'email'
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response body should contain "value is not a valid email address"

  @TS-TEST-17 @TC-TEST-17-9
  Scenario: TC9: Login attempt with a null value for 'password'
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response body should contain "password"

  @TS-TEST-17 @TC-TEST-17-10
  Scenario: TC10: Login attempt with an empty string for 'password'
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response body should contain "password"

  @TS-TEST-17 @TC-TEST-17-11
  Scenario: TC11: Login attempt with an invalidly formatted email
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response body should contain "value is not a valid email address"

  @TS-TEST-17 @TC-TEST-17-12
  Scenario: TC12: Login attempt with an empty JSON object request body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response body should contain "email"
    And the response body should contain "password"

  @TS-TEST-17 @TC-TEST-17-13
  Scenario: TC13: Login attempt with a null or empty request body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-17 @TC-TEST-17-14
  Scenario: TC14: Login attempt with a malformed JSON request body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 400

  @TS-TEST-17 @TC-TEST-17-15
  Scenario: TC15: Login attempt with security probe payloads (SQLi/XSS)
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
