Feature: Logout and Token Revocation
  As an authenticated user
  I want to log out of the application
  So that my access token is invalidated and my session is securely terminated

Background:
  Given the API base URL is set
  # This background performs a login to get a valid token for the subsequent scenarios.
  # It uses pre-configured credentials via {{auth.*}} tokens, resolved at runtime.
  And I have the following payload:
  """
  {
    "username": "{{auth.username}}",
    "password": "{{auth.password}}"
  }
  """
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 200
  And I save "data.access_token" from the response as "accessToken"
  Given I have the following headers:
    | Authorization | Bearer {{accessToken}} |

@TS-TEST-19
@TC-TEST-19-1
@dryrun
Scenario: TC1: Successful logout with a valid access token
  When I send a "POST" request to "/api/v1/auth/logout"
  Then the response status code should be 200
  And the response field "status" should be "true"
  And the response field "message" should be "Logged out successfully"
  And the response field "status_code" should be "200"

@TS-TEST-19
@TC-TEST-19-2
@TC-TEST-19-6
Scenario: TC2 & TC6: Re-use a revoked token after a successful logout
  # This scenario covers both TC2 (re-use a revoked token) and TC6 (double logout).
  # First, log out to revoke the token.
  When I send a "POST" request to "/api/v1/auth/logout"
  Then the response status code should be 200
  And the response field "message" should be "Logged out successfully"
  # Now, attempt to use the same, now-revoked token again.
  When I send a "POST" request to "/api/v1/auth/logout"
  Then the response status code should be 401
  And the response field "status" should be "false"
  And the response field "message" should be "Token has been revoked"
  And the response field "status_code" should be "401"

@TS-TEST-19
@TC-TEST-19-3
Scenario: TC3: Logout attempt without Authorization header
  Given I do not have an authorization token
  When I send a "POST" request to "/api/v1/auth/logout"
  Then the response status code should be 401
  And the response field "status" should be "false"
  And the response field "message" should be "Could not validate credentials"
  And the response field "status_code" should be "401"

@TS-TEST-19
@TC-TEST-19-4
Scenario: TC4: Logout attempt with a malformed token
  Given I have the following headers:
    | Authorization | Bearer invalid.token.string |
  When I send a "POST" request to "/api/v1/auth/logout"
  Then the response status code should be 401
  And the response field "status" should be "false"
  And the response field "message" should be "Could not validate credentials"
  And the response field "status_code" should be "401"

@TS-TEST-19
@TC-TEST-19-5
Scenario: TC5: Logout attempt with an expired token
  # This uses a sample expired JWT. The server should reject it based on the 'exp' claim.
  Given I have the following headers:
    | Authorization | Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjE1MTYyMzkwMjJ9.Of4b-s_2YGI-J-X2z2-AKs3J_x4CoG5dPRay84ex_uY |
  When I send a "POST" request to "/api/v1/auth/logout"
  Then the response status code should be 401
  And the response field "status" should be "false"
  And the response field "message" should be "Could not validate credentials"
  And the response field "status_code" should be "401"
