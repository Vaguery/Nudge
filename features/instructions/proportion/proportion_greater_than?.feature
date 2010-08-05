Feature: proportion_greater_than? instruction
  In order to compare numerical values
  As a modeler
  I want a suite of Nudge instructions that compare their size
  
  Scenario Outline: proportion_greater_than?
    Given I have pushed "<arg1>" onto the :proportion stack
    And I have pushed "<arg2>" onto the :proportion stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be in position -1 of the :bool stack
    And stack :proportion should have depth 0
    
    Examples: proportion_greater_than?
    | arg1 | arg2 | instruction              | result |
    | 0.3  | 0.4  | proportion_greater_than? | false  |
    | 0.4  | 0.3  | proportion_greater_than? | true   |
    | 0.3  | 0.3  | proportion_greater_than? | false  |
