Feature: Termination conditions
  In order to select efficient algorithms
  As a modeler
  I want the interpreter to count the steps, watch the time, and stop when done
  
  
  Scenario: interpreter should stop when :exec stack is empty
    Given the execution counter is set to 12
    When I run the interpreter
    Then the execution counter should be 12
    
    
  Scenario: interpreter should count steps
    Given the execution counter is set to 12
    And I have pushed "do exec_flush" onto the :exec stack
    When I take one execution step
    Then the execution counter should be 13
    
    
  Scenario: interpreter should stop when the step count exceeds its limit
    Given the execution counter is set to 11
    And I have set the Interpreter's termination point_limit to 11
    And I have pushed "block {ref a ref b}" onto the :exec stack
    When I run the interpreter
    Then the execution counter should be 12
    And stack :exec should have depth 2
    And "ref a" should be in position -1 of the :exec stack
  
  
  Scenario: interpreter should stop when the evaluation time exceeds its limit
    Given I have set the Interpreter's termination time_limit to 2
    And the execution counter is set to 331
    And I have pushed "block {ref c ref d}" onto the :exec stack
    And the time counter is set to 2
    When I run the interpreter
    Then the execution counter should be 332
    And stack :exec should have depth 2
    And "ref c" should be in position -1 of the :exec stack
  
  
  Scenario: default step limit should be 3000 steps
    Given I have pushed "block { do exec_y ref g}" onto the :exec stack
    When I run the interpreter
    Then the execution counter should be 3000
  
  
  Scenario: default time limit should be 1 second
    Given I have pushed "block { do exec_y do foo_bar}" onto the :exec stack
    And I have set the Interpreter's termination point_limit to 1000000
    When I run the interpreter
    Then the time elapsed should be 1 second