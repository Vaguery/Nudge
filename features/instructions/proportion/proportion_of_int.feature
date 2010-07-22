Feature: Proportion of int
  In order to manipulate numeric quantities
  As a modeler
  I want Nudge to have a proportion_of_int instruction
  
  Scenario Outline: 
    Given I have pushed "<arg1>" onto the :proportion stack
    And I have pushed "<arg2>" onto the :int stack
    When I execute the Nudge instruction "proportion_of_int"
    Then "<result>" should be in position -1 of the :int stack
    And stack :int should have depth 1
    And stack :proportion should have depth 0
    
    Examples: 
    | arg1  | arg2 | result |
    | 0.8   | 10   | 8      |
    | 0.11  | 10   | 1      |
    | 0.11  | -10  | -1     |
    | 0.0   | 10   | 0      |
    | 0.213 | -100 | -21    |
    | 0.5   | 9    | 5      |
    | 0.55  | 10   | 6      |
    
