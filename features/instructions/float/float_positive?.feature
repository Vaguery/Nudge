Feature: float_positive? instruction
  In order to convert arbitrary :float values into :bools in an unbiased way
  As a modeler
  I want a float_positive? that returns true for zero or negative arguments
  
  Scenario Outline: 
    Given I have pushed "<arg1>" onto the :float stack
    When I execute the Nudge instruction "float_positive?"
    Then "<result>" should be in position -1 of the :bool stack
    And stack :bool should have depth 1
    And stack :float should have depth 0
    
    
      
    Examples: float_positive?
      | arg1 | result |
      | 3.3  | true   |
      | -4.4 | false  |
      | 0.0  | false  |
      | -0.0 | false  |
