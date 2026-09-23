package com.automation.api.steps;

import io.cucumber.java.en.Then;
import org.testng.Assert;

// This step is required for TC-LOGIN-006 to compare two full response bodies.
// Per coding/SKILL.md, new steps for a feature go into a new, feature-specific step class.
public class PostApiV1AuthLoginSteps {

    private final ApiContext context;

    public PostApiV1AuthLoginSteps(ApiContext context) {
        this.context = context;
    }

    /**
     * Compares two values stored in the ApiContext for equality.
     * This is useful for scenarios like user enumeration protection where two different
     * invalid requests must yield identical error responses.
     *
     * @param key1 The context key for the first value.
     * @param key2 The context key for the second value.
     */
    @Then("the saved context value {string} should be equal to the saved context value {string}")
    public void theSavedContextValueShouldBeEqualToTheSavedContextValue(String key1, String key2) {
        // The 'I save "." from the response' step saves the full response body as a JsonPath object,
        // which internally is a Map. Assert.assertEquals on two such maps will compare their content.
        Object value1 = context.get(key1);
        Object value2 = context.get(key2);
        Assert.assertEquals(value1, value2, "The responses stored in keys '" + key1 + "' and '" + key2 + "' should be identical but were not.");
    }
}
