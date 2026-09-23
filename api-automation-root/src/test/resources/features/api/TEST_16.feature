Feature: TEST-16 - Test User Registration API

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-16 @TC-TEST-16-1 @dryrun
  Scenario: TC1: Verify successful user registration with valid data
    Given I have a fresh payload for the following fields:
      | first_name | firstName |
      | last_name  | lastName  |
      | email      | email     |
      | password   | password  |
    And I set the request body field "confirm_password" to match the value of "password"
    And I save "email" from the request as "generatedEmail"
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 201
    And the response field "status" should be "true"
    And the response field "message" should be "Registration successful."
    And the response field "data.user_id" should not be null
    And the response field "data.email" should be "{{generatedEmail}}"

  @TS-TEST-16 @TC-TEST-16-2
  Scenario: TC2: Verify registration fails when email already exists
    # Step 1: Register a new user to ensure the email exists for the subsequent test step.
    Given I have a fresh payload for the following fields:
      | first_name | firstName |
      | last_name  | lastName  |
      | email      | email     |
      | password   | password  |
    And I set the request body field "confirm_password" to match the value of "password"
    And I save "email" from the request as "userEmail"
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 201

    # Step 2: Attempt to register again with the same email.
    Given I have the following payload:
    """
    {
      "first_name": "Duplicate",
      "last_name": "User",
      "email": "{{userEmail}}",
      "password": "Secure@Pass1",
      "confirm_password": "Secure@Pass1"
    }
    """
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 409
    And the response field "status" should be "false"
    And the response field "message" should be "An account with this email already exists"

  @TS-TEST-16 @TC-TEST-16-3
  Scenario: TC3: Verify registration fails when passwords do not match
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422

  @TS-TEST-16 @TC-TEST-16-4
  Scenario: TC4: Verify registration fails for an invalid email format
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422

  @TS-TEST-16 @TC-TEST-16-5
  Scenario: TC5: Verify validation error for missing a required field
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422

  @TS-TEST-16 @TC-TEST-16-6
  Scenario: TC6: Verify registration fails with a password shorter than 8 characters
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422

  @TS-TEST-16 @TC-TEST-16-7
  Scenario: TC7: Verify registration fails with a password missing an uppercase letter
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422
    And the response field "message" should be "Password does not meet requirements"

  @TS-TEST-16 @TC-TEST-16-8
  Scenario: TC8: Verify registration fails with a password missing a lowercase letter
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422

  @TS-TEST-16 @TC-TEST-16-9
  Scenario: TC9: Verify registration fails with a password missing a digit
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422

  @TS-TEST-16 @TC-TEST-16-10
  Scenario: TC10: Verify registration fails with a password missing a special character
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422
    And the response field "message" should be "Password does not meet requirements"

  @TS-TEST-16 @TC-TEST-16-11
  Scenario: TC11: Verify registration fails with a password containing whitespace
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422

  @TS-TEST-16 @TC-TEST-16-12
  Scenario: TC12: Verify validation error for an empty JSON object request body
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422

  @TS-TEST-16 @TC-TEST-16-13
  Scenario: TC13: Verify graceful handling of a malformed JSON request body
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 400
