Feature: int_positive? instruction
  In order to convert arbitrary :int values into :bools in an unbiased way
  As a modeler
  I want a int_positive? that returns true for zero or negative arguments
  
  Scenario Outline: 
    Given I have pushed "<arg1>" onto the :int stack
    When I execute the Nudge instruction "int_positive?"
    Then "<result>" should be in position -1 of the :bool stack
    And stack :bool should have depth 1
    And stack :int should have depth 0
    
    
      
    Examples: int_positive?
      | arg1 | result |
      | 3    | true   |
      | -4   | false  |
      | 0    | false  |
      | -0   | false  |
