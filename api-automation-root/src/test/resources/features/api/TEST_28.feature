Feature: Test Create Product API

  Background:
    # This background authenticates once for the feature. The login call itself uses
    # the framework's auto-payload resolution, likely sourcing credentials from
    # {{auth.username}} and {{auth.password}} tokens.
    Given the API base URL is set
    When I send a "POST" request to "/api/v1/auth/login"
    Then the response status code should be 200
    And I save "data.access_token" from the response as "accessToken"
    Given I have the following headers:
      | Authorization | Bearer {{accessToken}} |

  @TS-TEST-28
  @TC-1
  @dryrun
  Scenario: Verify successful product creation with all valid fields
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 201
    And the response field "status" should be "true"
    And the response field "message" should be "Product created successfully"
    And the response field "data.name" should be "{{name}}"
    And the response field "data.price" should be "{{price}}"
    And the response field "data.category" should be "{{category}}"

  @TS-TEST-28
  @TC-2
  Scenario: Verify product creation fails without authentication token
    And I do not have an authorization token
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 401
    And the response field "status" should be "false"
    And the response field "message" should be "Could not validate credentials"

  @TS-TEST-28
  @TC-3
  Scenario: Verify product creation fails with missing 'name' field
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-28
  @TC-4
  Scenario: Verify product creation fails with missing 'price' field
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-28
  @TC-5
  Scenario: Verify product creation fails with missing 'category' field
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-28
  @TC-6
  Scenario: Verify successful product creation with only required fields
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 201
    And the response field "data.name" should be "{{name}}"
    And the response field "data.id" should not be null

  @TS-TEST-28
  @TC-7
  Scenario: Verify product creation fails with empty 'name' field
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-28
  @TC-8
  Scenario: Verify product creation fails with 'name' exceeding max length
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-28
  @TC-9
  Scenario: Verify product creation fails with empty 'category' field
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-28
  @TC-10
  Scenario: Verify product creation fails with 'category' exceeding max length
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-28
  @TC-11
  Scenario: Verify product creation fails with negative 'price'
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-28
  @TC-12
  Scenario: Verify successful product creation with 'price' of zero
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 201
    And the response field "data.price" should be "0"

  @TS-TEST-28
  @TC-13
  Scenario: Verify product creation fails with negative 'stock_quantity'
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-28
  @TC-14
  Scenario: Verify successful product creation with 'stock_quantity' of zero
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 201
    And the response field "data.stock_quantity" should be "0"

  @TS-TEST-28
  @TC-15
  Scenario: Verify product creation fails with 'image_url' exceeding max length
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-28
  @TC-16
  Scenario: Verify product creation fails with non-boolean 'is_active' value
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-28
  @TC-17
  Scenario: Verify product creation fails with non-integer 'stock_quantity' value
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 422
    And the response field "message" should be "Validation failed"

  @TS-TEST-28
  @TC-18
  Scenario: Verify product creation fails with malformed JSON body
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 422

  @TS-TEST-28
  @TC-19
  Scenario: Verify product creation fails with JSON array body
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 422

  @TS-TEST-28
  @TC-20
  Scenario: Verify product creation fails with null request body
    When I send a "POST" request to "/api/v1/products"
    Then the response status code should be 422
