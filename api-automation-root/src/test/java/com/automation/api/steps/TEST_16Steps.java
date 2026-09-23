package com.automation.api.steps;

import io.cucumber.java.en.Given;
import java.util.Map;

public class TEST_16Steps {

    private final ApiContext context;

    public TEST_16Steps(ApiContext context) {
        this.context = context;
    }

    @Given("I set the request body field {string} to match the value of {string}")
    public void iSetTheRequestBodyFieldToMatchTheValueOf(String targetField, String sourceField) {
        // This step assumes an upstream step like 'I have a fresh payload for the following fields:'
        // has already created the 'requestBody' object in the ApiContext.
        if (!context.has("requestBody")) {
            throw new IllegalStateException("Request body not found in ApiContext. This step must be used after a payload creation step.");
        }

        Object body = context.get("requestBody");
        if (!(body instanceof Map)) {
            throw new IllegalStateException("Request body in ApiContext is not a Map. This step can only modify Map-based bodies.");
        }

        @SuppressWarnings("unchecked")
        Map<String, Object> requestBody = (Map<String, Object>) body;

        if (!requestBody.containsKey(sourceField)) {
            throw new IllegalStateException("Source field '" + sourceField + "' not found in request body.");
        }

        Object sourceValue = requestBody.get(sourceField);
        requestBody.put(targetField, sourceValue);

        // The 'requestBody' map in the context is mutable, so the change is effective immediately.
        // Re-saving to the context is redundant but harmless.
        context.save("requestBody", requestBody);
    }
}
