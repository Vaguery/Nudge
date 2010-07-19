Feature: proportion_multiply instruction
  In order to describe and manipulate proportional quantities and probabilities
  As a modeler
  I want a suite of :proportion Nudge arithmetic instructions
  
  Scenario Outline: proportion_multiply
    Given I have pushed "<arg1>" onto the :proportion stack
    And I have pushed "<arg2>" onto the :proportion stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be in position -1 of the :proportion stack
    And that stack's depth should be 1


  Examples: proportion_multiply
    | arg1 | arg2 | instruction         | result |
    | 0.1  | 0.2  | proportion_multiply | 0.02   |
    | 0.3  | 0.9  | proportion_multiply | 0.27   |
    | 0.0  | 0.1  | proportion_multiply | 0.0    |
    | 1.0  | 0.3  | proportion_multiply | 0.3    |
