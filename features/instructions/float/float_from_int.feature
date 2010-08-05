Feature: Float from int
  In order to convert numerics between the various types
  As a modeler
  I want Nudge to have an float_from_int instruction
  
  Scenario Outline: 
    Given I have pushed "<arg>" onto the :int stack
    When I execute the Nudge instruction "float_from_int"
    Then "<result>" should be in position -1 of the :float stack
    And stack :int should have depth 0
    
    
    Examples:
    | arg | result |
    | 11  | 11.0   |
    | -11 | -11.0  |
    | 0   | 0.0    |
    | -0  | 0.0    |
