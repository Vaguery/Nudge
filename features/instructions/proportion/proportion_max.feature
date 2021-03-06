Feature: proportion_max instruction
  In order to describe and manipulate proportional quantities and probabilities
  As a modeler
  I want a suite of :proportion Nudge arithmetic instructions
  
  Scenario Outline: proportion_max
    Given I have pushed "<arg1>" onto the :proportion stack
    And I have pushed "<arg2>" onto the :proportion stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be in position -1 of the :proportion stack
    And stack :proportion should have depth 1
    
  Examples: proportion_max
    | arg1 | arg2 | instruction    | result | 
    | 0.1  | 0.2  | proportion_max | 0.2    | 
    | 0.3  | 0.1  | proportion_max | 0.3    | 
    | 0.1  | 0.1  | proportion_max | 0.1    | 
  
  
