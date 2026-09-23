package com.automation.api.steps;

import io.cucumber.java.en.And;
import io.restassured.specification.RequestSpecification;

/**
 * Contains custom step definitions for scenarios that require header manipulation beyond the standard steps.
 */
public class PostApiV1AuthLogoutSteps {

    private final ApiContext context;

    /**
     * Constructor for dependency injection.
     * @param context The scenario-scoped context.
     */
    public PostApiV1AuthLogoutSteps(ApiContext context) {
        this.context = context;
    }

    /**
     * Removes a specified header from the request specification.
     * This is necessary for negative scenarios testing endpoints without a required header,
     * especially when a Background step has already set it.
     * @param headerName The name of the header to remove.
     */
    @And("I do not have an {string} header")
    public void iDoNotHaveAHeader(String headerName) {
        RequestSpecification requestSpec = (RequestSpecification) context.get("requestSpec");
        // The header must be removed from the FilterableRequestSpecification to be effective.
        // This prevents the header from being sent in the actual HTTP request.
        ((io.restassured.specification.FilterableRequestSpecification) requestSpec).removeHeader(headerName);
    }
}
