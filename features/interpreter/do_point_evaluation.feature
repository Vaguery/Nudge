Feature: Do point evaluation
  In order to manipulate values
  As a modeler
  I want the Nudge interpreter to execute an instruction immediately
  
  Scenario: :exec stack should be popped when all prerequisites are met
    Given I have pushed "do int_add" onto the :exec stack
    And I have pushed "2" onto the :int stack
    And I have pushed "-1" onto the :int stack
    When I take one execution step
    Then stack :exec should have depth 0
    And the execution counter should be 1
    
    
  Scenario: instruction handling when arguments are missing
    Given I have pushed "do int_add" onto the :exec stack
    And I have pushed "4" onto the :int stack
    When I take one execution step
    Then stack :exec should have depth 0
    And stack :error should have depth 1
    And the execution counter should be 1
  
  
  Scenario: instruction handling when instruction is inactive or unknown
    Given I have pushed "do be_do_be_doo" onto the :exec stack
    When I take one execution step
    Then stack :exec should have depth 0
    And stack :error should have depth 1
    And "UnknownInstruction: be_do_be_doo not recognized" should be in position -1 of the :error stack
    And the execution counter should be 1
    
