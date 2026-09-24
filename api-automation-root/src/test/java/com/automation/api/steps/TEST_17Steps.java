package com.automation.api.steps;

import io.cucumber.java.en.Then;
import io.restassured.response.Response;
import org.testng.Assert;

import java.util.Map;

public class TEST_17Steps {

    private final ApiContext context;

    public TEST_17Steps(ApiContext context) {
        this.context = context;
    }

    /**
     * Compares the current full JSON response body against a JSON object saved in the ApiContext.
     * This is more robust than string comparison as it ignores differences in JSON formatting (e.g., whitespace, key order).
     * It is used to verify consistent error message structures, such as for user enumeration protection.
     * The saved value is expected to be a Map or List, as stored by the 'I save "." from the response as ...' step.
     * @param name The context key for the previously saved JSON object.
     */
    @Then("the response should be identical to the saved JSON object {string}")
    public void theResponseShouldBeIdenticalToTheSavedJsonObject(String name) {
        Response response = (Response) context.get("response");
        // Deserialize the current response body into a Map for comparison.
        Map<String, Object> currentBody = response.getBody().as(Map.class);

        // Retrieve the saved object from the context, which should also be a Map.
        @SuppressWarnings("unchecked")
        Map<String, Object> savedBody = (Map<String, Object>) context.get(name);

        // Assert that the two maps are equal. This compares keys and values recursively.
        Assert.assertEquals(currentBody, savedBody, "Response JSON objects should be identical to prevent user enumeration.");
    }
}
