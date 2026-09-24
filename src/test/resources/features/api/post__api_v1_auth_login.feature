Feature: API Login Endpoint
  As a user, I want to authenticate via the API to get an access token.

  Background:
    Given the API base URL is set

  @TC-LOGIN-001
  Scenario: Successful login for an MFA-disabled user
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "data.token_type" should be "bearer"
    And the response field "data.mfa_required" should be "false"
    And the response field "data.access_token" should not be null

  @TC-LOGIN-002
  Scenario: Successful credential validation for an MFA-enabled user
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "data.mfa_required" should be "true"
    And the response field "data.pre_auth_token" should not be null

  @TC-LOGIN-003
  Scenario: Login with a valid email and an incorrect password
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TC-LOGIN-004
  Scenario: Login with a non-existent email address
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Invalid email or password"

  @TC-LOGIN-005
  Scenario: Login with an invalid email format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "message" should be "Validation failed"
    And the response field "errors.email[0]" should be "Enter a valid email"

  @TC-LOGIN-006
  Scenario: Login with a missing email field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "errors.email[0]" should be "Field required"

  @TC-LOGIN-007
  Scenario: Login with a missing password field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "status" should be "false"
    And the response field "errors.password[0]" should be "Field required"

  @TC-LOGIN-008
  Scenario: Login with an empty JSON object
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422
    And the response field "errors.email[0]" should be "Field required"
    And the response field "errors.password[0]" should be "Field required"

  @TC-LOGIN-009
  Scenario: Login with a malformed JSON body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 400

  @TC-LOGIN-010
  Scenario: Login with an unsupported content type
    Given I have the following headers:
      | Content-Type | application/xml |
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 415
