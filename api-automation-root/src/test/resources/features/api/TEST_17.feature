Feature: TEST-17: Test Login API
Tests the user authentication endpoint /api/v1/auth/login.
Covers successful login for both MFA-enabled and MFA-disabled users,
as well as various negative and boundary conditions.
The requirement for TC6 (preventing user enumeration) is met by ensuring
TC4 (invalid password) and TC5 (non-existent user) have identical 401 responses.

Background:
Given the API base URL is set

@TS-TEST-17 @TC-TEST-17-001 @dryrun
Scenario: TC1: Successful login for user with MFA disabled
When I send a "POST" request to "/api/v1/auth/login"
Then the response status code should be 200
And the response field "status" should be "true"
And the response field "message" should be "Login successful"
And the response field "data.mfa_required" should be "null"
And the response field "data.token_type" should be "bearer"
And the response field "data.access_token" should not be null
And the response field "data.pre_auth_token" should be "null"

@TS-TEST-17 @TC-TEST-17-002
Scenario: TC2: Successful login first step for user with MFA enabled
And the response field "data.mfa_required" should be "true"
And the response field "data.pre_auth_token" should not be null
And the response field "data.access_token" should be "null"

@TS-TEST-17 @TC-TEST-17-003
Scenario: TC3: Validate successful login response structure for MFA-disabled user
And the response should match the "post_api_v1_auth_login_mfa_disabled_response.schema.json" schema

@TS-TEST-17 @TC-TEST-17-004
Scenario: TC4: Login attempt with incorrect password
Then the response status code should be 401
And the response field "message" should be "Invalid email or password"

@TS-TEST-17 @TC-TEST-17-005
Scenario: TC5: Login attempt with non-existent email

@TS-TEST-17 @TC-TEST-17-007
Scenario: TC7: Login attempt with missing email field
Then the response status code should be 422

@TS-TEST-17 @TC-TEST-17-008
Scenario: TC8: Login attempt with missing password field

@TS-TEST-17 @TC-TEST-17-009
Scenario: TC9: Login attempt with invalid email format

@TS-TEST-17 @TC-TEST-17-010
Scenario: TC10: Login attempt with empty string for email

@TS-TEST-17 @TC-TEST-17-011
Scenario: TC11: Login attempt with empty string for password

@TS-TEST-17 @TC-TEST-17-012
Scenario: TC12: Login attempt with empty JSON object

@TS-TEST-17 @TC-TEST-17-013
Scenario: TC13: Login attempt with malformed JSON body
Then the response status code should be 400

@TS-TEST-17 @TC-TEST-17-014
Scenario: TC14: Login attempt with null request body
