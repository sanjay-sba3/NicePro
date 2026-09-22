package com.automation.api.steps;

import com.automation.api.steps.ApiContext;
import io.cucumber.java.en.Given;
import io.restassured.specification.FilterableRequestSpecification;
import io.restassured.specification.RequestSpecification;

/**
 * Step definitions for the TEST-17 feature, generated to cover specific cases
 * not handled by existing generic steps in ApiSteps.java.
 */
public class Test_17Steps {

    private final ApiContext context;

    /**
     * Constructor for Test_17Steps, injected with ApiContext for shared scenario state.
     * @param context The scenario-scoped ApiContext instance.
     */
    public Test_17Steps(ApiContext context) {
        this.context = context;
    }

    /**
     * Removes a specified header from the request specification.
     * This step is used for negative test cases where a missing or removed header
     * needs to be explicitly tested, as the 'I have the following headers:' step
     * only adds or replaces headers.
     * Confirmed live: Casting to `FilterableRequestSpecification` is required to access `removeHeader`.
     * @param headerName The name of the header to remove.
     */
    @Given("I remove the header {string}")
    public void iRemoveTheHeader(String headerName) {
        // Retrieve the current request specification from ApiContext
        RequestSpecification requestSpec = (RequestSpecification) context.get("requestSpec");
        // Cast to FilterableRequestSpecification to access the removeHeader method
        ((FilterableRequestSpecification) requestSpec).removeHeader(headerName);
        System.out.println("Removed header: " + headerName + " from request.");
    }
}
