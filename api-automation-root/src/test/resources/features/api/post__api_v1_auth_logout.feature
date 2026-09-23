Feature: Test Logout and Token Revocation API
  Validate logout functionality and access token revocation to verify successful logout, invalid tokens, token blacklisting, and behavior when a revoked token is reused.

  Background:
    Given the API base URL is set
    # The logout endpoint and its negative cases require a valid token to be generated first.
    # This background performs a login to acquire a token, which scenarios can then use or manipulate.
    # The login payload uses {{auth.*}} tokens which are resolved at runtime from a secure source.
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And I save "data.access_token" from the response as "accessToken"

  @TS-TEST-19 @TC-TEST-19-1 @dryrun
  Scenario: Successful logout with a valid access token
    Given I have the following headers:
      | Authorization | Bearer {{accessToken}} |
    And I have the following payload:
      """
      {}
      """
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "Logged out successfully"

  @TS-TEST-19 @TC-TEST-19-2
  Scenario: Attempt to re-use a revoked access token
    Given I have the following headers:
      | Authorization | Bearer {{accessToken}} |
    And I have the following payload:
      """
      {}
      """
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 200
    # Attempt to use the same, now-revoked token again
    And I have the following payload:
      """
      {}
      """
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Token has been revoked"

  @TS-TEST-19 @TC-TEST-19-3
  Scenario: Logout attempt without Authorization header
    # The Background sets the Authorization header, so this step explicitly removes it for this scenario.
    And I do not have an "Authorization" header
    And I have the following payload:
      """
      {}
      """
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Could not validate credentials"

  @TS-TEST-19 @TC-TEST-19-4
  Scenario: Logout attempt with a malformed token
    # This step overrides the valid token from the Background
    Given I have the following headers:
      | Authorization | Bearer invalid.token.string |
    And I have the following payload:
      """
      {}
      """
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Could not validate credentials"

  @TS-TEST-19 @TC-TEST-19-5
  Scenario: Logout attempt with an expired token
    # This step overrides the valid token from the Background with a sample expired token
    Given I have the following headers:
      | Authorization | Bearer expired.but.validly.signed.token |
    And I have the following payload:
      """
      {}
      """
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Could not validate credentials"

  @TS-TEST-19 @TC-TEST-19-6
  Scenario: Double logout attempt with the same token
    Given I have the following headers:
      | Authorization | Bearer {{accessToken}} |
    And I have the following payload:
      """
      {}
      """
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 200
    And the response field "message" should be "Logged out successfully"
    # Immediately attempt to log out again with the same, now-revoked token
    And I have the following payload:
      """
      {}
      """
    When I send a "POST" request to "/api/v1/auth/logout"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Token has been revoked"
