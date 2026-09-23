package com.automation.api.steps;

import com.automation.api.utils.SchemaValidator;
import io.cucumber.java.en.Then;
import io.restassured.response.Response;

/**
 * Contains custom step definitions for the Login API feature (TEST-17).
 */
public class TEST_17Steps {

    private final ApiContext context;

    /**
     * Constructor for dependency injection.
     * @param context The shared scenario context, injected by Cucumber-PicoContainer.
     */
    public TEST_17Steps(ApiContext context) {
        this.context = context;
    }

    /**
     * Validates the response body against a specified JSON schema file.
     * This step is necessary when an endpoint has multiple, distinct success response schemas
     * and the default auto-derived schema name from the generic step is insufficient.
     * @param schemaName The name of the schema file located in src/test/resources/schemas/.
     */
    @Then("the response should match the {string} schema")
    public void theResponseShouldMatchTheSchema(String schemaName) {
        // Retrieve the response from the context, which is saved by a 'When I send...' step.
        Response response = (Response) context.get("response");

        // Delegate validation to the existing SchemaValidator utility.
        SchemaValidator.validate(response, schemaName);
    }
}
