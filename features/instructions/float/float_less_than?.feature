Feature: float_less_than? instruction
  In order to compare machine-precision numerical values
  As a modeler
  I want a suite of :float Nudge instructions that compare their size
  
  Scenario Outline: float_less_than?
    Given I have pushed "<arg1>" onto the :float stack
    And I have pushed "<arg2>" onto the :float stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be in position -1 of the :bool stack
    And stack :float should have depth 0
    
    Examples: float_less_than?
    | arg1        | arg2 | instruction      | result |
    | 3.0         | 4.1  | float_less_than? | true   |
    | 4.1         | 3.0  | float_less_than? | false  |
    | 3.0         | 3.0  | float_less_than? | false  |
    | 3.300000001 | 3.3  | float_less_than? | false  |
    | -2.5        | 16.0 | float_less_than? | true   |
    | -2.5        | -4.0 | float_less_than? | false  |
