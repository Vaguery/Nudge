Feature: Proportion of float
  In order to manipulate numeric quantities
  As a modeler
  I want Nudge to have a proportion_of_float instruction
  
  Scenario Outline: 
    Given I have pushed "<arg1>" onto the :proportion stack
    And I have pushed "<arg2>" onto the :float stack
    When I execute the Nudge instruction "proportion_of_float"
    Then something close to "<result>" should be in position -1 of the :float stack
    And stack :float should have depth 1
    And stack :proportion should have depth 0
    
    Examples: 
    | arg1 | arg2   | result |
    | 0.8  | 10.0   | 8.0    |
    | 0.11 | 10.0   | 1.1    |
    | 0.11 | -10.0  | -1.1   |
    | 0.0  | 10.0   | 0.0    |
    | 0.2  | -100.0 | -20.0  |
    
