Feature: Test Logout and Token Revocation API

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-19 @TC-1 @dryrun
  Scenario: Successful Login - MFA Disabled
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "message" should be "Login successful"
    And the response field "data.mfa_required" should be "false"
    And the response field "data.access_token" should not be null

  @TS-TEST-19 @TC-2
  Scenario: Successful Login - MFA Enabled (Pre-Auth Token)
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And the response field "message" should be "MFA verification required"
    And the response field "data.mfa_required" should be "true"
    And the response field "data.pre_auth_token" should not be null

  @TS-TEST-19 @TC-3
  Scenario: Login Request - Missing Email Field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-19 @TC-4
  Scenario: Login Request - Missing Password Field
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-19 @TC-5
  Scenario: Login Request - Invalid Email Format
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-19 @TC-6
  Scenario: Login Request - Incorrect Email (User Enumeration Prevention)
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-19 @TC-7
  Scenario: Login Request - Incorrect Password (User Enumeration Prevention)
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 401
    And the response field "message" should be "Invalid email or password"

  @TS-TEST-19 @TC-8
  Scenario: Login Request - Malformed JSON Body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 400

  @TS-TEST-19 @TC-9
  Scenario: Login Request - Empty JSON Object Body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-19 @TC-10
  Scenario: Login Request - Null Request Body
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 422

  @TS-TEST-19 @TC-11 @dryrun
  Scenario: Successful Logout and Token Revocation
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And I save "data.access_token" from the response as "accessToken"
    Given I have the following headers:
      | Authorization | Bearer {{accessToken}} |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 200
    And the response field "message" should be "Logged out successfully"

  @TS-TEST-19 @TC-12
  Scenario: Logout Request - Missing Authorization Header
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Could not validate credentials"

  @TS-TEST-19 @TC-13
  Scenario: Logout Request - Invalidly Formatted Authorization Token
    Given I have the following headers:
      | Authorization | Bearer invalid-format-token |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Could not validate credentials"

  @TS-TEST-19 @TC-14
  Scenario: Logout Request - Expired Authorization Token
    Given I have the following headers:
      | Authorization | Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ0ZXN0X2V4cGlyZWQiLCJleHAiOjE2NzgwNTExOTl9.exampleExpiredTokenABC |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Could not validate credentials"

  @TS-TEST-19 @TC-15
  Scenario: Logout Request - Already Revoked Authorization Token
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And I save "data.access_token" from the response as "accessToken"
    Given I have the following headers:
      | Authorization | Bearer {{accessToken}} |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 200
    Given I have the following headers:
      | Authorization | Bearer {{accessToken}} |
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "message" should be "Token has been revoked"