package com.automation.api.steps;

import io.cucumber.java.en.And;

public class TEST_28Steps {

    private final ApiContext context;

    public TEST_28Steps(ApiContext context) {
        this.context = context;
    }

    @And("I do not have an authorization token")
    public void iDoNotHaveAnAuthorizationToken() {
        // This step removes the Authorization header, which may have been set by the Background.
        // It's intended for scenarios that explicitly test unauthenticated access.
        // The cast to FilterableRequestSpecification is necessary to access header removal methods.
        ((io.restassured.specification.FilterableRequestSpecification) this.context.get("requestSpec"))
            .removeHeader("Authorization");
    }
}
