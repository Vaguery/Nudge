Feature: proportion_complement instruction
  In order to describe and manipulate proportional quantities and probabilities
  As a modeler
  I want a suite of :proportion Nudge arithmetic instructions
  
  Scenario Outline: proportion_complement
    Given I have pushed "<arg1>" onto the :proportion stack
    When I execute the Nudge instruction "<instruction>"
    Then something close to "<result>" should be in position -1 of the :proportion stack
    And stack :proportion should have depth 1
    
    Examples: proportion_complement
      | arg1  | instruction           | result |
      | 0.123 | proportion_complement | 0.877  |
      | 0.9   | proportion_complement | 0.1    |
      | 0.0   | proportion_complement | 1.0    |
      | 1.0   | proportion_complement | 0.0    |
      
