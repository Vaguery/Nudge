Feature: int_greater_than? instruction
  In order to compare numerical values
  As a modeler
  I want a suite of Nudge instructions that compare their size
  
  Scenario Outline: int_greater_than?
    Given I have pushed "<arg1>" onto the :int stack
    And I have pushed "<arg2>" onto the :int stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be in position -1 of the :bool stack
    And stack :int should have depth 0
    
    Examples: int_greater_than?

    | arg1 | arg2 | instruction       | result |
    | 3    | 4    | int_greater_than? | false  |
    | 4    | 3    | int_greater_than? | true   |
    | 3    | 3    | int_greater_than? | false  |
    | -2   | 16   | int_greater_than? | false  |
    | -2   | -4   | int_greater_than? | true   |
