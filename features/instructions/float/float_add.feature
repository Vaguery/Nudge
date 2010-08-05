Feature: float_add
  In order to describe and manipulate machine-precision numerical variables
  As a modeler
  I want a suite of :float Nudge arithmetic instructions
  
  Scenario Outline: 
    Given I have pushed "<arg1>" onto the :float stack
    And I have pushed "<arg2>" onto the :float stack
    When I execute the Nudge instruction "<instruction>"
    Then something close to "<result>" should be in position -1 of the :float stack
    And stack :float should have depth 1
    
    Examples: float_add
      | arg1 | arg2  | instruction | result | 
      | 12.1 | -12.0 | float_add   | 0.1    | 
      | 0.0  | 3.3   | float_add   | 3.3    | 
      | -2.0 | -2.0  | float_add   | -4.0   | 
