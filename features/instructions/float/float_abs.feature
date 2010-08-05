Feature: float_abs instruction
  In order to describe and manipulate machine-precision numerical variables
  As a modeler
  I want a suite of :float Nudge arithmetic instructions
  
  Scenario Outline:
    Given I have pushed "<arg1>" onto the :float stack
    When I execute the Nudge instruction "<instruction>"
    Then something close to "<result>" should be in position -1 of the :float stack
    And stack :float should have depth 1
    
    Examples: float_abs
      | arg1  | instruction | result | 
      | 11.1  | float_abs   | 11.1   | 
      | -12.0 | float_abs   | 12.0   | 
      | 0.0   | float_abs   | 0.0    | 
      | -0.0  | float_abs   | 0.0    | 
