Feature: Sensors
  In order to get return values from an interpreter
  As a modeler
  I want to specify return values, and procedures for deriving them from the final interpreter state
  
  
  Scenario: value peek sensor
    Given an interpreter set to run "value «int» \n«int» 88"
    And I bind a sensor called "y1" to the peeked value of the :int stack
    When I run the program
    Then the return value should include the information that y1 is 88
    
    
  Scenario: value pop sensor
    Given an interpreter set to run "block {value «float» value «float»}\n«float» 1.1 \n«float» 2.2"
    And I bind a sensor called "y1" to the popped value of the :float stack
    And I bind "y2" to the popped value of the :float
    When I run the program
    Then the return value should include info that y1 is 2.2
    And y2 is 1.1
    
    
  Scenario: missing values
    Given an interpreter set to run "value «int» \n«int» 77"
    And I bind sensor "y1" to the peeked value of :float
    When I run the program
    Then the return value should include info that y1 has no value
    
    
  Scenario: stack size sensor
    Given an interpreter set to run "value «int» \n«int» 77"
    And I bind sensor "y1" to the stack depth of :int
    When I run the program
    Then the return value should include info that y1 is 1
    
    
  Scenario: step count sensor should be a default
    Given an interpreter set to run "block {value «float» value «float»}\n«float» 1.1 \n«float» 2.2"
    When I run the program
    Then the return value should include info that step_count is 3
    
    
  Scenario: runtime sensor should be a default
    Given an interpreter set to run "block {do exec_y ref x}"
    When I run the program
    Then the return value should include info that run_time is slightly more than the time limit
    
    
  Scenario: running without extra sensors
    Given an interpreter
    When I run "do int_add"
    Then the return value should include the step_count and run_time sensors
