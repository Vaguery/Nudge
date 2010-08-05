Feature: proportion_bounded_add instruction
  In order to describe and manipulate proportional quantities and probabilities
  As a modeler
  I want a suite of :proportion Nudge arithmetic instructions
  
  Scenario Outline: proportion_bounded_add
    Given I have pushed "<arg1>" onto the :proportion stack
    And I have pushed "<arg2>" onto the :proportion stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be in position -1 of the :proportion stack
    And that stack's depth should be 1
    
    Examples: proportion_bounded_add
      | arg1 | arg2 | instruction            | result |
      | 0.6  | 0.2  | proportion_bounded_add | 0.8    |
      | 0.9  | 0.2  | proportion_bounded_add | 1.0    |
      | 0.0  | 0.4  | proportion_bounded_add | 0.4    |
