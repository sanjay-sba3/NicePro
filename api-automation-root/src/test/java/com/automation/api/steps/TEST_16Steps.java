package com.automation.api.steps;

import io.cucumber.java.en.Then;
import io.restassured.response.Response;
import org.testng.Assert;

public class TEST_16Steps {

    private final ApiContext context;

    public TEST_16Steps(ApiContext context) {
        this.context = context;
    }

    /**
     * Asserts that the response body contains a specific substring.
     * This is useful for checking error messages in arrays or less structured responses
     * where a specific GPath assertion is not practical.
     * @param expectedText The text expected to be present in the response body.
     */
    @Then("the response body should contain {string}")
    public void theResponseBodyShouldContain(String expectedText) {
        // Fetch the raw response body as a string to perform a contains check.
        Response response = (Response) context.get("response");
        String responseBody = response.getBody().asString();
        // The expected text can contain placeholders like {{name}}, which should be resolved.
        String resolvedExpectedText = context.resolvePlaceholders(expectedText);
        Assert.assertTrue(responseBody.contains(resolvedExpectedText),
                "Response body was expected to contain '" + resolvedExpectedText + "', but it did not. Body was: \n" + responseBody);
    }
}
