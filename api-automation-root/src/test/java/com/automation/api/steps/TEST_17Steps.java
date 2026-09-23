package com.automation.api.steps;

import io.cucumber.java.en.Then;
import io.restassured.response.Response;
import org.testng.Assert;

public class TEST_17Steps {

    private final ApiContext context;

    public TEST_17Steps(ApiContext context) {
        this.context = context;
    }

    @Then("the response should indicate MFA is required and include a pre-authentication token")
    public void theResponseShouldIndicateMfaIsRequired() {
        Response response = (Response) context.get("response");

        // Per the Jira story, the response should indicate MFA is required.
        // We'll assert a field like 'data.mfa_required' is true and a 'data.pre_auth_token' exists.
        // The exact field names are inferred from the requirement text as they are not in the provided API spec.
        Boolean mfaRequired = response.path("data.mfa_required");
        String preAuthToken = response.path("data.pre_auth_token");

        Assert.assertNotNull(mfaRequired, "Response body should contain 'data.mfa_required' field.");
        Assert.assertTrue(mfaRequired, "The 'data.mfa_required' field should be true.");
        Assert.assertNotNull(preAuthToken, "Response body should contain a 'data.pre_auth_token'.");
        Assert.assertFalse(preAuthToken.isEmpty(), "The 'data.pre_auth_token' should not be empty.");
    }
}
