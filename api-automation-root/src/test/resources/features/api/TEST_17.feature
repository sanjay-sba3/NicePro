Feature: Test Login API

  Background:
    Given the API base URL is set
    And I have a valid authentication token

@TS-TEST-17
@TC-1
@dryrun
Scenario: TC1: Successful login for user with MFA disabled
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 200
  And the response field "status" should be "true"
  And the response field "message" should be "Login successful"
  And the response field "data.token_type" should be "bearer"
  And the response field "data.access_token" should not be null

@TS-TEST-17
@TC-2
Scenario: TC2: Login attempt with valid email and incorrect password
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 401
  And the response field "status" should be "false"
  And the response field "message" should be "Invalid email or password"

@TS-TEST-17
@TC-3
Scenario: TC3: Login attempt with a non-existent email
  # This scenario, along with TC2, covers the requirement of TC4:
  # ensuring identical responses for incorrect password and non-existent user.
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 401
  And the response field "status" should be "false"
  And the response field "message" should be "Invalid email or password"

@TS-TEST-17
@TC-5
Scenario: TC5: Login attempt with missing email field
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "message" should be "Validation failed"
  And the response field "errors[0].loc[1]" should be "email"

@TS-TEST-17
@TC-6
Scenario: TC6: Login attempt with missing password field
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "message" should be "Validation failed"
  And the response field "errors[0].loc[1]" should be "password"

@TS-TEST-17
@TC-7
Scenario: TC7: Login attempt with an empty JSON object body
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "message" should be "Validation failed"

@TS-TEST-17
@TC-8
Scenario: TC8: Login attempt with a non-string value for email
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "message" should be "Validation failed"
  And the response field "errors[0].msg" should be "value is not a valid email address"

@TS-TEST-17
@TC-9
Scenario: TC9: Login attempt with a non-string value for password
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "message" should be "Validation failed"
  And the response field "errors[0].loc[1]" should be "password"

@TS-TEST-17
@TC-10
Scenario: TC10: Login attempt with an empty string for email
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "message" should be "Validation failed"
  And the response field "errors[0].msg" should be "value is not a valid email address"

@TS-TEST-17
@TC-11
Scenario: TC11: Login attempt with a null value for email
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "message" should be "Validation failed"
  And the response field "errors[0].loc[1]" should be "email"

@TS-TEST-17
@TC-12
Scenario: TC12: Login attempt with a malformed JSON body
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 400

@TS-TEST-17
@TC-13
Scenario: TC13: Login attempt with a null request body
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "message" should be "Validation failed"

@TS-TEST-17
@TC-14
Scenario: TC14: Login attempt with a JSON array as request body
  When I send a "POST" request to "/api/v1/auth/login"
  Then the response status code should be 422
  And the response field "message" should be "Validation failed"
