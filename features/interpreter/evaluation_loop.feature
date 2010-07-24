Feature: Evaluation loop
  In order to run Nudge programs
  As a modeler
  I want the interpreter to be able to handle all five basic program points
      
    
  
  Scenario: instruction handling when all prerequisites are met
    Given an interpreter with "do int_add" on :exec
    And two :int values on the :int stack, with values "2" and "3"
    When I take one execution step
    Then the arguments should disappear from :int
    And a new value "5" should be on :int
    And nothing should be on the :exec stack
    
    
  Scenario: instruction handling when arguments are missing
    Given an interpreter with "do int_add" on :exec
    And one :int value "4" on the :int stack
    When I take one execution step
    Then nothing should be on the :int stack
    And nothing should be on the :exec stack
    And a new :error value "int_add lacks one or more arguments"
  
  
  Scenario: instruction handling when instruction is inactive or unknown
    Given an interpreter with "do foo_bar" on :exec
    When I take one execution step
    Then nothing should be on the :exec stack
    And a new :error value "'foo_bar' is not a known instruction"
  
