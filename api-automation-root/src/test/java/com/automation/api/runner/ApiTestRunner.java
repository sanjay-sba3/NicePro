package com.automation.api.runner;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;
import io.cucumber.testng.FeatureWrapper;
import io.cucumber.testng.PickleWrapper;
import org.testng.annotations.DataProvider;
import java.util.ArrayList;
import java.util.List;

@CucumberOptions(
    features = "src/test/resources/features/api",
    glue = {"com.automation.api.steps"},
    // "io.qameta.allure.cucumber7jvm.AllureCucumber7Jvm" writes target/allure-results during
    // the run itself (its own built-in default location, matching pom.xml's allure-maven
    // <resultsDirectory> for `mvn allure:report` to read back from) -- adding the dependency
    // alone does nothing without also registering it as a Cucumber plugin here.
    plugin = {"pretty", "html:target/cucumber-reports/cucumber-pretty.html", "json:target/cucumber-reports/cucumber.json", "com.automation.api.runner.DryRunProgressListener", "io.qameta.allure.cucumber7jvm.AllureCucumber7Jvm"}
)
public class ApiTestRunner extends AbstractTestNGCucumberTests {

    @Override
    // parallel = true -- safe because every scenario gets its own fresh ApiContext/
    // RequestSpecification (PicoContainer creates one instance per scenario, see ApiContext's
    // class comment), and the only other shared mutable state (SuiteAuthContext,
    // DryRunProgressListener's completed counter) is already synchronized/atomic. TestNG's
    // default dataProviderThreadCount (10) applies since no testng.xml overrides it -- tune via
    // -Ddataproviderthreadcount=N if 10 concurrent scenarios overloads the target API.
    @DataProvider(parallel = true)
    public Object[][] scenarios() {
        Object[][] allScenarios = super.scenarios();
        String featureFilter = System.getProperty("test.feature");
        System.out.println("[DEBUG Runner] Total scenarios loaded from classpath: " + allScenarios.length);
        System.out.println("[DEBUG Runner] test.feature system property filter: [" + featureFilter + "]");
        
        if (featureFilter == null || featureFilter.isEmpty() || featureFilter.equals("all-scenarios.feature")) {
            return allScenarios;
        }

        List<Object[]> filtered = new ArrayList<>();
        for (Object[] scenario : allScenarios) {
            PickleWrapper pickleWrapper = (PickleWrapper) scenario[0];
            String uri = pickleWrapper.getPickle().getUri().toString();
            System.out.println("[DEBUG Runner] Comparing filter with Scenario URI: [" + uri + "]");
            if (uri.contains(featureFilter)) {
                filtered.add(scenario);
            }
        }
        System.out.println("[DEBUG Runner] Total scenarios after filtering: " + filtered.size());
        return filtered.toArray(new Object[0][0]);
    }
}
