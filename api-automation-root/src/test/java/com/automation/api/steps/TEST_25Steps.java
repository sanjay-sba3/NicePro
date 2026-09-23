package com.automation.api.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import org.testng.Assert;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class TEST_25Steps {

    private final ApiContext context;

    public TEST_25Steps(ApiContext context) {
        this.context = context;
    }

    @Given("I have the following query parameters:")
    public void iHaveTheFollowingQueryParameters(DataTable dataTable) {
        RequestSpecification requestSpec = (RequestSpecification) context.get("requestSpec");
        Map<String, String> params = dataTable.asMap(String.class, String.class);
        requestSpec.queryParams(params);
    }

    @Then("all products in the response should have their name containing {string}")
    public void allProductsInTheResponseShouldHaveTheirNameContaining(String expectedSubstring) {
        Response response = (Response) context.get("response");
        JsonPath jsonPath = response.jsonPath();
        List<String> names = jsonPath.getList("data.items.name");
        Assert.assertFalse(names.isEmpty(), "Product list should not be empty for this check.");
        for (String name : names) {
            Assert.assertTrue(name.contains(expectedSubstring), "Product name '" + name + "' does not contain '" + expectedSubstring + "'.");
        }
    }

    @Then("all products in the response should have category {string}")
    public void allProductsInTheResponseShouldHaveCategory(String expectedCategory) {
        Response response = (Response) context.get("response");
        JsonPath jsonPath = response.jsonPath();
        List<String> categories = jsonPath.getList("data.items.category");
        Assert.assertFalse(categories.isEmpty(), "Product list should not be empty for this check.");
        for (String category : categories) {
            Assert.assertEquals(category, expectedCategory, "Product category was '" + category + "' but expected '" + expectedCategory + "'.");
        }
    }

    @Then("all products in the response should have a price between {string} and {string}")
    public void allProductsInTheResponseShouldHaveAPriceBetween(String minPriceStr, String maxPriceStr) {
        Response response = (Response) context.get("response");
        JsonPath jsonPath = response.jsonPath();
        List<String> prices = jsonPath.getList("data.items.price");
        BigDecimal minPrice = new BigDecimal(minPriceStr);
        BigDecimal maxPrice = new BigDecimal(maxPriceStr);
        Assert.assertFalse(prices.isEmpty(), "Product list should not be empty for this check.");
        for (String priceStr : prices) {
            BigDecimal price = new BigDecimal(priceStr);
            Assert.assertTrue(price.compareTo(minPrice) >= 0 && price.compareTo(maxPrice) <= 0, "Product price '" + price + "' is not between '" + minPrice + "' and '" + maxPrice + "'.");
        }
    }

    @Then("all products in the response should have a rating of {string} or greater")
    public void allProductsInTheResponseShouldHaveARatingOfOrGreater(String minRatingStr) {
        Response response = (Response) context.get("response");
        JsonPath jsonPath = response.jsonPath();
        List<String> ratings = jsonPath.getList("data.items.rating");
        BigDecimal minRating = new BigDecimal(minRatingStr);
        Assert.assertFalse(ratings.isEmpty(), "Product list should not be empty for this check.");
        for (String ratingStr : ratings) {
            BigDecimal rating = new BigDecimal(ratingStr);
            Assert.assertTrue(rating.compareTo(minRating) >= 0, "Product rating '" + rating + "' is not greater than or equal to '" + minRating + "'.");
        }
    }

    @Then("the products in the response should be sorted by {string} in {string} order")
    public void theProductsInTheResponseShouldBeSortedByInOrder(String sortBy, String sortOrder) {
        Response response = (Response) context.get("response");
        JsonPath jsonPath = response.jsonPath();
        List<Map<String, Object>> items = jsonPath.getList("data.items");
        Assert.assertTrue(items.size() > 1, "Sorting cannot be verified with less than two items.");

        List<Comparable> originalValues = items.stream()
                .map(item -> {
                    // Prices and ratings are strings but need numeric comparison.
                    if (sortBy.equals("price") || sortBy.equals("rating")) {
                        return new BigDecimal(item.get(sortBy).toString());
                    }
                    return (Comparable) item.get(sortBy);
                })
                .collect(Collectors.toList());

        List<Comparable> sortedValues = new ArrayList<>(originalValues);
        if ("ascending".equalsIgnoreCase(sortOrder) || ("asc".equalsIgnoreCase(sortOrder))) {
            sortedValues.sort(null);
        } else {
            sortedValues.sort(Comparator.reverseOrder());
        }

        Assert.assertEquals(originalValues, sortedValues, "The products are not sorted correctly by '" + sortBy + "' in '" + sortOrder + "' order.");
    }

    @Then("the response field {string} should be empty")
    public void theResponseFieldShouldBeEmpty(String gpath) {
        Response response = (Response) context.get("response");
        List<?> list = response.jsonPath().getList(gpath);
        Assert.assertTrue(list.isEmpty(), "Expected response field '" + gpath + "' to be an empty list, but it was not.");
    }

    @Then("the size of response array {string} should be at most {int}")
    public void theSizeOfResponseArrayShouldBeAtMost(String gpath, int maxSize) {
        Response response = (Response) context.get("response");
        List<?> list = response.jsonPath().getList(gpath);
        Assert.assertTrue(list.size() <= maxSize, "Expected size of array '" + gpath + "' to be at most '" + maxSize + "', but was '" + list.size() + "'.");
    }

    @Then("the size of response array {string} should be {int}")
    public void theSizeOfResponseArrayShouldBe(String gpath, int expectedSize) {
        Response response = (Response) context.get("response");
        List<?> list = response.jsonPath().getList(gpath);
        Assert.assertEquals(list.size(), expectedSize, "Expected size of array '" + gpath + "' to be '" + expectedSize + "', but was '" + list.size() + "'.");
    }

    @Then("the response should contain a validation error for query parameter {string}")
    public void theResponseShouldContainAValidationErrorForQueryParameter(String fieldName) {
        Response response = (Response) context.get("response");
        JsonPath jsonPath = response.jsonPath();
        List<Map<String, Object>> errors = jsonPath.getList("errors");
        boolean fieldFound = errors.stream().anyMatch(error -> {
            List<String> loc = (List<String>) error.get("loc");
            // Location for query parameters is typically ["query", "fieldName"]
            return loc != null && loc.contains("query") && loc.contains(fieldName);
        });
        Assert.assertTrue(fieldFound, "Response did not contain a validation error for query parameter '" + fieldName + "'.");
    }
}