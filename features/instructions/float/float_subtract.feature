Feature: float_subtract
  In order to describe and manipulate machine-precision numerical variables
  As a modeler
  I want a suite of :float Nudge arithmetic instructions

  Scenario Outline: 
    Given I have pushed "<arg1>" onto the :float stack
    And I have pushed "<arg2>" onto the :float stack
    When I execute the Nudge instruction "<instruction>"
    Then something close to "<result>" should be in position -1 of the :float stack
    And stack :float should have depth 1
  
  
  Examples: float_subtract
    | arg1 | arg2 | instruction    | result |
    | 3.0  | 4.1  | float_subtract | -1.1   |
    | 5.6  | 3.3  | float_subtract | 2.3    |
    | -2.0 | -3.1 | float_subtract | 1.1    |
    | -3.1 | -2.0 | float_subtract | -1.1   |
