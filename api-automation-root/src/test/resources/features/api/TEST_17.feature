Feature: Test Login API

  Background:
    Given the API base URL is set
    # The 'I have a valid authentication token' step is a no-op, which is correct for a login endpoint.
    And I have a valid authentication token

@TS-TEST-17 @TC-1 @dryrun
Scenario: TC1: Successful login with valid credentials (MFA disabled)
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 200
  And the response field "status" should be "true"
  And the response field "message" should be "Login successful"
  And the response field "data.token_type" should be "bearer"
  And the response field "data.access_token" should not be null

@TS-TEST-17 @TC-2
Scenario: TC2: Successful login with valid credentials (MFA enabled)
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 200
  And the response field "status" should be "true"
  # Per requirements, response must indicate MFA is required and include a pre-auth token.
  # The exact response fields are assumed based on this requirement.
  And the response field "message" should be "MFA verification required"
  And the response field "data.pre_auth_token" should not be null

@TS-TEST-17 @TC-3
Scenario: TC3: Login attempt with invalid password
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 401
  And the response field "status" should be "false"
  And the response field "message" should be "Invalid email or password"

@TS-TEST-17 @TC-4
Scenario: TC4: Login attempt with invalid email
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 401
  And the response field "status" should be "false"
  And the response field "message" should be "Invalid email or password"

@TS-TEST-17 @TC-5
Scenario: TC5: Login attempt for a non-existent user
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 401
  And the response field "status" should be "false"
  And the response field "message" should be "Invalid email or password"

@TS-TEST-17 @TC-6
Scenario: TC6: Login attempt with missing email field
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "status" should be "false"
  And the response field "message" should be "Validation failed"

@TS-TEST-17 @TC-7
Scenario: TC7: Login attempt with missing password field
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "status" should be "false"
  And the response field "message" should be "Validation failed"

@TS-TEST-17 @TC-8
Scenario: TC8: Login attempt with an empty request body
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "status" should be "false"
  And the response field "message" should be "Validation failed"

@TS-TEST-17 @TC-9
Scenario: TC9: Login attempt with null email value
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "status" should be "false"
  And the response field "message" should be "Validation failed"

@TS-TEST-17 @TC-10
Scenario: TC10: Login attempt with null password value
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "status" should be "false"
  And the response field "message" should be "Validation failed"

@TS-TEST-17 @TC-11
Scenario: TC11: Login attempt with non-string email value
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "status" should be "false"
  And the response field "message" should be "Validation failed"

@TS-TEST-17 @TC-12
Scenario: TC12: Login attempt with non-string password value
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "status" should be "false"
  And the response field "message" should be "Validation failed"

@TS-TEST-17 @TC-13
Scenario: TC13: Login attempt with malformed JSON body
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 400
