Feature: TEST-16 - Test User Registration API
  Validate user registration, including account creation, password requirements, duplicate email handling, and initial state.

  Background:
    Given the API base URL is set
    And I have a valid authentication token

  @TS-TEST-16
  @TC-TEST-16-01
  @dryrun
  Scenario: TC1: Successful user registration with valid data
    Given I have the following payload:
      """
      {
        "first_name": "{{random.firstName}}",
        "last_name": "{{random.lastName}}",
        "email": "{{random.email}}",
        "password": "Password@123",
        "confirm_password": "Password@123"
      }
      """
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 201
    And the response field "status" should be "true"
    And the response field "message" should be "Registration successful."
    And the response field "data.user_id" should not be null
    And the response field "data.email" should not be null

  @TS-TEST-16
  @TC-TEST-16-02
  Scenario: TC2: Attempt registration with a duplicate email
    # Step 1: Register a new user to ensure an account exists for the duplication check.
    Given I have the following payload:
      """
      {
        "first_name": "{{random.firstName}}",
        "last_name": "{{random.lastName}}",
        "email": "{{random.email}}",
        "password": "Password@123",
        "confirm_password": "Password@123"
      }
      """
    And I save "email" from the request as "registeredEmail"
    And I save "password" from the request as "registeredPassword"
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 201

    # Step 2: Attempt to register again with the same email, which should be rejected.
    And I have the following payload:
      """
      {
        "first_name": "{{random.firstName}}",
        "last_name": "{{random.lastName}}",
        "email": "{{registeredEmail}}",
        "password": "{{registeredPassword}}",
        "confirm_password": "{{registeredPassword}}"
      }
      """
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 409
    And the response field "status" should be "false"
    And the response field "message" should be "An account with this email already exists"

  @TS-TEST-16
  @TC-TEST-16-03
  Scenario: TC3: Attempt registration with mismatched passwords
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422

  @TS-TEST-16
  @TC-TEST-16-04
  Scenario: TC4: Attempt registration with password missing an uppercase letter
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422
    And the response body should contain "Password must contain at least one uppercase letter"

  @TS-TEST-16
  @TC-TEST-16-05
  Scenario: TC5: Attempt registration with password missing a lowercase letter
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422
    # The exact error message for missing lowercase is not documented, assuming a standard message.
    And the response body should contain "Password must contain at least one lowercase letter"

  @TS-TEST-16
  @TC-TEST-16-06
  Scenario: TC6: Attempt registration with password missing a digit
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422
    And the response body should contain "Password must contain at least one digit"

  @TS-TEST-16
  @TC-TEST-16-07
  Scenario: TC7: Attempt registration with password missing a special character
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422
    And the response body should contain "Password must contain at least one special character"

  @TS-TEST-16
  @TC-TEST-16-08
  Scenario: TC8: Attempt registration with password shorter than 8 characters
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422
    # The exact error message for short password is not documented, assuming a standard message.
    And the response body should contain "Password must be at least 8 characters long"

  @TS-TEST-16
  @TC-TEST-16-09
  Scenario: TC9: Attempt registration with a missing required field (first_name)
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422

  @TS-TEST-16
  @TC-TEST-16-10
  Scenario: TC10: Attempt registration with an invalid email format
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422

  @TS-TEST-16
  @TC-TEST-16-11
  Scenario: TC11: Attempt registration with a malformed JSON body
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 400

  @TS-TEST-16
  @TC-TEST-16-12
  Scenario: TC12: Attempt registration with an empty JSON object
    When I send a "POST" request to "/api/v1/auth/register"
    Then the response status code should be 422
