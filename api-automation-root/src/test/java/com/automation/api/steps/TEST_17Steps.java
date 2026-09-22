package com.automation.api.steps;

import io.cucumber.java.en.Given;
import io.restassured.specification.FilterableRequestSpecification;

public class TEST_17Steps {

    private final ApiContext context;

    public TEST_17Steps(ApiContext context) {
        this.context = context;
    }

    @Given("I remove the {string} header")
    public void iRemoveTheHeader(String headerName) {
        // This step is used to test scenarios where a default header,
        // like Content-Type, should be explicitly omitted from the request.
        // It uses FilterableRequestSpecification to modify the request built so far.
        FilterableRequestSpecification requestSpec = (FilterableRequestSpecification) context.get("requestSpec");
        requestSpec.removeHeader(headerName);
    }
}
