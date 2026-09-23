Feature: Test List Products API
  Validate the product listing API, including search, category filtering, price and rating filters, and pagination.

  Background:
    Given the API base URL is set

  @TS-TEST-25 @TC-1 @dryrun
  Scenario: TC1: Verify successful product list retrieval with valid API key
    Given I have the following query parameters:
      | api_key | abc-123-def-456 |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 200
    And the response field "status" should be "true"
    And the response field "data" should not be null
    And the response field "data.items" should not be null

  @TS-TEST-25 @TC-2
  Scenario: TC2: Verify product search with a full-text query
    Given I have the following query parameters:
      | api_key | abc-123-def-456 |
      | search  | Water           |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 200
    And all products in the response should have their name containing "Water"

  @TS-TEST-25 @TC-3
  Scenario: TC3: Verify product filtering by a valid category
    Given I have the following query parameters:
      | api_key  | abc-123-def-456 |
      | category | Beverages       |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 200
    And all products in the response should have category "Beverages"

  @TS-TEST-25 @TC-4
  Scenario: TC4: Verify product filtering by a valid price range
    Given I have the following query parameters:
      | api_key   | abc-123-def-456 |
      | price_min | 5               |
      | price_max | 10              |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 200
    And all products in the response should have a price between "5" and "10"

  @TS-TEST-25 @TC-5
  Scenario: TC5: Verify product filtering by a minimum rating
    Given I have the following query parameters:
      | api_key    | abc-123-def-456 |
      | rating_min | 4.0             |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 200
    And all products in the response should have a rating of "4.0" or greater

  @TS-TEST-25 @TC-6
  Scenario: TC6: Verify sorting by price in ascending order
    Given I have the following query parameters:
      | api_key    | abc-123-def-456 |
      | sort_by    | price           |
      | sort_order | asc             |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 200
    And the products in the response should be sorted by "price" in "ascending" order

  @TS-TEST-25 @TC-7
  Scenario: TC7: Verify sorting by name in descending order
    Given I have the following query parameters:
      | api_key    | abc-123-def-456 |
      | sort_by    | name            |
      | sort_order | desc            |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 200
    And the products in the response should be sorted by "name" in "descending" order

  @TS-TEST-25 @TC-8
  Scenario: TC8: Verify sorting by rating
    Given I have the following query parameters:
      | api_key | abc-123-def-456 |
      | sort_by | rating          |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 200
    And the products in the response should be sorted by "rating" in "descending" order

  @TS-TEST-25 @TC-9
  Scenario: TC9: Verify sorting by popularity
    Given I have the following query parameters:
      | api_key | abc-123-def-456 |
      | sort_by | popularity      |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 200
    And the response field "data.items" should not be null

  @TS-TEST-25 @TC-10
  Scenario: TC10: Verify combined search, filter, and sort functionality
    Given I have the following query parameters:
      | api_key    | abc-123-def-456 |
      | search     | Water           |
      | category   | Beverages       |
      | sort_by    | price           |
      | sort_order | asc             |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 200
    And all products in the response should have their name containing "Water"
    And all products in the response should have category "Beverages"
    And the products in the response should be sorted by "price" in "ascending" order

  @TS-TEST-25 @TC-11
  Scenario: TC11: Verify pagination by requesting a specific page
    Given I have the following query parameters:
      | api_key | abc-123-def-456 |
      | page    | 2               |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 200
    And the response field "data.page" should be "2"

  @TS-TEST-25 @TC-12
  Scenario: TC12: Verify page_size parameter limits results per page
    Given I have the following query parameters:
      | api_key   | abc-123-def-456 |
      | page_size | 5               |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 200
    And the response field "data.page_size" should be "5"
    And the size of response array "data.items" should be at most 5

  @TS-TEST-25 @TC-13
  Scenario: TC13: Verify request fails without an API key
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 401

  @TS-TEST-25 @TC-14
  Scenario: TC14: Verify request fails with an invalid API key
    Given I have the following query parameters:
      | api_key | invalid-key-789 |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 403

  @TS-TEST-25 @TC-15
  Scenario: TC15: Verify filtering by a non-existent category returns empty list
    Given I have the following query parameters:
      | api_key  | abc-123-def-456     |
      | category | NonExistentCategory |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 200
    And the response field "data.items" should be empty
    And the response field "data.total" should be "0"

  @TS-TEST-25 @TC-16
  Scenario: TC16: Verify validation error for non-numeric price filter
    Given I have the following query parameters:
      | api_key   | abc-123-def-456 |
      | price_min | abc             |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 422
    And the response should contain a validation error for query parameter "price_min"

  @TS-TEST-25 @TC-17
  Scenario: TC17: Verify validation error for non-numeric rating filter
    Given I have the following query parameters:
      | api_key    | abc-123-def-456 |
      | rating_min | xyz             |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 422
    And the response should contain a validation error for query parameter "rating_min"

  @TS-TEST-25 @TC-18
  Scenario: TC18: Verify graceful handling of unsupported sort field
    Given I have the following query parameters:
      | api_key | abc-123-def-456     |
      | sort_by | unsupported_field |
    When I send a "GET" request to "/api/v1/products"
    # The expected result allows for 422 or 200. A 422 is a clearer signal for an invalid parameter.
    Then the response status code should be 422
    And the response should contain a validation error for query parameter "sort_by"

  @TS-TEST-25 @TC-19
  Scenario: TC19: Verify validation error for non-integer page number
    Given I have the following query parameters:
      | api_key | abc-123-def-456 |
      | page    | one             |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 422
    And the response should contain a validation error for query parameter "page"

  @TS-TEST-25 @TC-20
  Scenario: TC20: Verify validation error for negative price filter
    Given I have the following query parameters:
      | api_key   | abc-123-def-456 |
      | price_min | -10             |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 422
    And the response should contain a validation error for query parameter "price_min"

  @TS-TEST-25 @TC-21
  Scenario: TC21: Verify validation error for page number 0
    Given I have the following query parameters:
      | api_key | abc-123-def-456 |
      | page    | 0               |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 422
    And the response should contain a validation error for query parameter "page"

  @TS-TEST-25 @TC-22
  Scenario: TC22: Verify validation error for negative page number
    Given I have the following query parameters:
      | api_key | abc-123-def-456 |
      | page    | -1              |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 422
    And the response should contain a validation error for query parameter "page"

  @TS-TEST-25 @TC-23
  Scenario: TC23: Verify response for page number greater than total pages
    Given I have the following query parameters:
      | api_key | abc-123-def-456 |
      | page    | 999             |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 200
    And the response field "data.items" should be empty

  @TS-TEST-25 @TC-24
  Scenario: TC24: Verify filtering with a minimum price of zero
    Given I have the following query parameters:
      | api_key   | abc-123-def-456 |
      | price_min | 0               |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 200
    And all products in the response should have a rating of "0" or greater

  @TS-TEST-25 @TC-25
  Scenario: TC25: Verify requesting page 1 with a valid page size
    Given I have the following query parameters:
      | api_key   | abc-123-def-456 |
      | page      | 1               |
      | page_size | 10              |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 200
    And the response field "data.page" should be "1"
    And the size of response array "data.items" should be at most 10

  @TS-TEST-25 @TC-26
  Scenario: TC26: Verify page size of 1 returns a single product
    Given I have the following query parameters:
      | api_key   | abc-123-def-456 |
      | page_size | 1               |
    When I send a "GET" request to "/api/v1/products"
    Then the response status code should be 200
    And the response field "data.page_size" should be "1"
    And the size of response array "data.items" should be 1
