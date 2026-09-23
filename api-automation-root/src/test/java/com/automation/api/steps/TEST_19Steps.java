package com.automation.api.steps;

import io.cucumber.java.en.Given;
import io.restassured.specification.RequestSpecification;

/**
 * Contains custom step definitions for the Logout and Token Revocation feature.
 */
public class TEST_19Steps {

    private final ApiContext context;

    /**
     * Constructor for dependency injection.
     * @param context The scenario-scoped context object.
     */
    public TEST_19Steps(ApiContext context) {
        this.context = context;
    }

    /**
     * Removes the 'Authorization' header from the request specification.
     * This is used for scenarios testing endpoints that should fail when no
     * authentication is provided, overriding any token set in a Background step.
     */
    @Given("I do not have an authorization token")
    public void iDoNotHaveAnAuthorizationToken() {
        RequestSpecification requestSpec = (RequestSpecification) context.get("requestSpec");
        // The spec needs to be cast to FilterableRequestSpecification to allow header removal.
        // This is a confirmed-live pattern from the coding standards.
        ((io.restassured.specification.FilterableRequestSpecification) requestSpec).removeHeader("Authorization");
    }
}
