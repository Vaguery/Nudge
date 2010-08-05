Feature: Int from float
  In order to convert numerics between the various types
  As a modeler
  I want Nudge to have an int_from_float instruction
  
  Scenario Outline: 
    Given I have pushed "<arg>" onto the :float stack
    When I execute the Nudge instruction "int_from_float"
    Then "<result>" should be in position -1 of the :int stack
    And stack :float should have depth 0
    
    
    Examples:
    | arg   | result |
    | 11.1  | 11     |
    | -11.1 | -11    |
    | -11.6 | -12    |
    | 0.1   | 0      |
    | 0.5   | 1      |
    | 1.5   | 2      |
    | -0.5  | -1     |
