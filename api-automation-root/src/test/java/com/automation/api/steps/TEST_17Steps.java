package com.automation.api.steps;

import io.cucumber.java.en.When;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;

public class TEST_17Steps {

    private final ApiContext context;

    public TEST_17Steps(ApiContext context) {
        this.context = context;
    }

    @When("I send a {string} request to {string} {int} times")
    public void iSendARequestMultipleTimes(String method, String path, int count) {
        // This custom step is for scenarios requiring repeated requests, like rate limit testing.
        // WARNING: The framework's automatic TC-ID-based payload resolution is tightly coupled
        // with the main `iSendARequestTo` step in ApiSteps.java. This custom step cannot call that
        // step directly. For this step to work correctly with the TC-ID payload mechanism,
        // the payload resolution and body attachment logic from `ApiSteps.maybeAutoResolvePayload`
        // must be replicated or refactored into a shared utility that this step can also call.
        // The implementation below performs the request loop but omits the payload logic for brevity and safety.
        // A developer must add the payload handling logic from the existing framework before execution.

        RequestSpecification requestSpec = (RequestSpecification) context.get("requestSpec");
        String resolvedPath = context.resolvePlaceholders(path);

        Response response = null;
        for (int i = 0; i < count; i++) {
            // The body should be resolved and set onto the requestSpec here for each iteration.
            // Without this, the same request (or an empty body) will be sent repeatedly.

            switch (method.toUpperCase()) {
                case "POST":
                    response = requestSpec.post(resolvedPath);
                    break;
                case "GET":
                    response = requestSpec.get(resolvedPath);
                    break;
                case "PUT":
                    response = requestSpec.put(resolvedPath);
                    break;
                case "PATCH":
                    response = requestSpec.patch(resolvedPath);
                    break;
                case "DELETE":
                    response = requestSpec.delete(resolvedPath);
                    break;
                default:
                    throw new IllegalArgumentException("Unsupported HTTP method: " + method);
            }
        }

        // Per framework convention, save the *last* response for subsequent assertions.
        context.save("response", response);
        // Per framework convention, clear the requestBody to avoid it being reused by a subsequent step in a journey.
        if (context.has("requestBody")) {
            context.clear("requestBody");
        }
    }
}
