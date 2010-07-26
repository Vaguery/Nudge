Feature: float_negative instruction
  In order to describe and manipulate machine-precision numerical variables
  As a modeler
  I want a suite of :float Nudge arithmetic instructions
  
  Scenario Outline: 
    Given I have pushed "<arg1>" onto the :float stack
    When I execute the Nudge instruction "<instruction>"
    Then something close to "<result>" should be in position -1 of the :float stack
    And stack :float should have depth 1
    
      
    Examples: float_negative
      | arg1 | instruction     | result |
      | 3.3  | float_negative | -3.3   |
      | -4.4 | float_negative | 4.4    |
      | 0.0  | float_negative | 0.0    |
      | -0.0 | float_negative | 0.0    |
