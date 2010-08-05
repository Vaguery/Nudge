Feature: Termination conditions
  In order to select efficient algorithms
  As a modeler
  I want the interpreter to count the steps, watch the time, and stop when done
  
  
  Scenario: interpreter should stop when :exec stack is empty
    # Given the execution counter is set to 12
    # When I take one execution step
    # Then the execution counter should be 12
    
    
  Scenario: interpreter should count steps
    Given the execution counter is set to 12
    And I have pushed "do exec_flush" onto the :exec stack
    When I take one execution step
    Then the execution counter should be 13
    
    
  Scenario: interpreter should stop when the step count reaches its limit
    # Given the execution counter is set to 11
    # And the execution limit is set to 11
    # And I have pushed "do exec_flush" onto the :exec stack
    # When I take one execution step
    # Then the step count should be 12
    # And "do exec_flush" should still be on the :exec stack
  
  
  Scenario: interpreter should stop when the evaluation time exceeds its limit
    # Given an interpreter with a time limit of 2 seconds
    # And "block {ref x ref y ref z}" on the :exec stack
    # When I introduce a one second wait between each evaluation step
    # And run the program
    # Then the interpreter should stop running the program before terminating
    # And some of the code should be left on the :exec stack
  
  
  Scenario: default step limit should be 3000 steps
    # Given a new interpreter
    # When I create a new interpreter
    # Then its step limit should be 3000
  
  
  Scenario: default time limit should be 1 second
    # Given no external changes
    # When I create a new interpreter
    # Then its time limit should be 1 second
    
    
  Scenario: setting the step limit should be an optional parameter of running a script
    # Given an interpreter
    # When I tell it to run "block {exec_y ref x}"
    # And pass in an optional parameter step limit = 22
    # Then it should terminate with some items left on the :exec stack
    # And some copies of "ref x" on the :name stack
  
  
  Scenario: setting the time limit should be an optional parameter of running a script
    # Given an interpreter
    # When I tell it to run "block {exec_y ref x}"
    # And pass in an optional parameter time limit = 1 second
    # Then it should terminate with some items left on the :exec stack
    # And some copies of "ref x" on the :name stack
  
  
  Scenario: it should be possible to take a single step using a method call
    # Given an interpreter with step counter = 0
    # And "block {block {}}"
    # When I take one evaluation step
    # Then the :exec stack should contain "block {}"
    # And the step counter should be 1
    # And it should not run any farther
    
    
  Scenario: it should be possible to run until termination using a method call
    # Given an interpreter with default termination condition
    # And "block {exec_y ref x}" on the :exec stack
    # When I run the script
    # Then the interpreter should halt by itself
    # And it should have either 3000 steps or slightly more than 5 seconds
