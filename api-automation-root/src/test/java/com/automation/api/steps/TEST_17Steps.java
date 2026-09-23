package com.automation.api.steps;

import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import org.testng.Assert;

public class TEST_17Steps {

    private final ApiContext context;

    public TEST_17Steps(ApiContext context) {
        this.context = context;
    }

    /**
     * Validates that the login response indicates MFA is required.
     * This is based on a specific business flow described in JIRA TEST-17,
     * where a successful login for an MFA-enabled user returns a pre-authentication token
     * instead of a final access token. The exact response message and field names are assumed
     * based on the Jira description.
     */
    @Then("the response should indicate MFA is required")
    public void theResponseShouldIndicateMfaIsRequired() {
        Response response = (Response) context.get("response");
        JsonPath jsonPath = response.jsonPath();

        // Per JIRA TEST-17, the response for an MFA-enabled user should indicate
        // that the next step is MFA verification.
        // Note: The exact message is an assumption based on the test case description.
        Assert.assertTrue(jsonPath.getString("message").contains("MFA verification is required"), "Response message should indicate MFA is required.");
        Assert.assertEquals(jsonPath.getBoolean("status"), true, "Response status should be true for pre-authentication success.");

        // The response should contain a pre-authentication token for the next step.
        Assert.assertNotNull(jsonPath.get("data.pre_auth_token"), "Response should contain a pre-authentication token.");

        // The response should NOT contain a final access token at this stage.
        Assert.assertNull(jsonPath.get("data.access_token"), "Response should not contain a final access token before MFA verification.");
    }
}
