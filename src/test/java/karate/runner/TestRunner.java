package karate.runner;

import com.intuit.karate.junit5.Karate;

class TestRunner {
    
    @Karate.Test
    Karate TestRunner() {
        return Karate.run("classpath:resources/features/createPetStore.feature").relativeTo(getClass());
    }

}
