Feature: float_sqrt instruction
  In order to describe and manipulate machine-precision numerical variables
  As a modeler
  I want a suite of :float Nudge arithmetic instructions
  
  Scenario Outline: float_sqrt
    Given I have pushed "<arg1>" onto the :float stack
    When I execute the Nudge instruction "<instruction>"
    Then something close to "<result>" should be in position -1 of the :float stack
    And "<error_msg>" should be in position -1 of the :error stack
    And stack :float should have depth <d>
    
    Examples: float_sqrt
      | arg1  | instruction | result | error_msg                                  | d |
      | 64.0  | float_sqrt  | 8.0    |                                            | 1 |
      | 0.0   | float_sqrt  | 0.0    |                                            | 1 |
      | -0.0  | float_sqrt  | 0.0    |                                            | 1 |
      | 1.0   | float_sqrt  | 1.0    |                                            | 1 |
      | -1.0  | float_sqrt  |        | NaN: result of square root was not a float | 0 |
      | -64.0 | float_sqrt  |        | NaN: result of square root was not a float | 0 |
