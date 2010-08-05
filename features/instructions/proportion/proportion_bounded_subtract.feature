Feature: proportion_bounded_subtract instruction
  In order to describe and manipulate proportional quantities and probabilities
  As a modeler
  I want a suite of :proportion Nudge arithmetic instructions
  
  Scenario Outline: proportion_bounded_subtract
    Given I have pushed "<arg1>" onto the :proportion stack
    And I have pushed "<arg2>" onto the :proportion stack
    When I execute the Nudge instruction "<instruction>"
    Then something close to "<result>" should be in position -1 of the :proportion stack
    And stack :proportion should have depth 1


  Examples: proportion_bounded_subtract
    | arg1 | arg2 | instruction                 | result |
    | 0.6  | 0.2  | proportion_bounded_subtract | 0.4    |
    | 0.2  | 0.6  | proportion_bounded_subtract | 0.0    |
    | 0.3  | 0.0  | proportion_bounded_subtract | 0.3    |
