Feature: Test Get User Profile API

  Validate the API for retrieving the current user's profile. Generate test scenarios and test cases to verify profile retrieval with valid authentication, unauthorized requests, and the expected profile response structure.

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-21
  @TC-TEST-21-001
  @dryrun
  Scenario: TC1: Verify successful profile retrieval with a valid token
    Given I have the following headers:
      | Authorization | Bearer {{auth.otp}} |
    When I send a "GET" request to "/api/v1/users/me"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "message" should be "Profile retrieved successfully"
    And the response field "data" should not be null

  @TS-TEST-21
  @TC-TEST-21-002
  Scenario: TC2: Verify the structure and content of the retrieved user profile
    Given I have the following headers:
      | Authorization | Bearer {{auth.otp}} |
    When I send a "GET" request to "/api/v1/users/me"
    Then the response status code should be 200
    And the response should match the response schema
    And the response field "data.id" should not be null
    And the response field "data.bio" should not be null
    And the response field "data.email" should not be null
    And the response field "data.is_active" should not be null
    And the response field "data.last_name" should not be null
    And the response field "data.created_at" should not be null
    And the response field "data.first_name" should not be null
    And the response field "data.occupation" should not be null
    And the response field "data.updated_at" should not be null
    And the response field "data.preferences" should not be null
    And the response field "data.phone_number" should not be null
    And the response field "data.profile_photo" should not be null

  @TS-TEST-21
  @TC-TEST-21-003
  Scenario: TC3: Verify unauthorized error for request with no authentication token
    When I send a "GET" request to "/api/v1/users/me"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Could not validate credentials"

  @TS-TEST-21
  @TC-TEST-21-004
  Scenario: TC4: Verify unauthorized error for request with an invalid token
    Given I have the following headers:
      | Authorization | Bearer invalid-or-malformed-token-string |
    When I send a "GET" request to "/api/v1/users/me"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Could not validate credentials"

  @TS-TEST-21
  @TC-TEST-21-005
  Scenario: TC5: Verify unauthorized error for request with an expired token
    Given I have the following headers:
      | Authorization | Bearer an_expired_but_validly_formatted_token |
    When I send a "GET" request to "/api/v1/users/me"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Could not validate credentials"

  @TS-TEST-21
  @TC-TEST-21-006
  Scenario: TC6: Verify not found error for a deleted user's token
    Given I have the following headers:
      | Authorization | Bearer valid_token_for_deleted_user |
    When I send a "GET" request to "/api/v1/users/me"
    Then the response status code should be 404
    And the response field "status" should be "false"
    And the response field "message" should be "User not found"
