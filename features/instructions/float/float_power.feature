Feature: float_power instruction
  In order to describe and manipulate machine-precision numerical variables
  As a modeler
  I want a suite of :float Nudge arithmetic instructions
  
  Scenario Outline: float_power
    Given I have pushed "<arg1>" onto the :float stack
    And I have pushed "<arg2>" onto the :float stack
    When I execute the Nudge instruction "<instruction>"
    Then something close to "<result>" should be in position -1 of the :float stack
    And "<error_msg>" should be in position -1 of the :error stack
    And stack :float should have depth <d>
      
      
    Examples: float_power
      | arg1 | arg2 | instruction | result           | error_msg | d |
      | 0.2  | 1.0  | float_power | 0.2              |           | 1 |
      | 0.2  | 2.0  | float_power | 0.04             |           | 1 |
      | -0.2 | 2.0  | float_power | 0.04             |           | 1 |
      | 12.8 | 3.1  | float_power | 2706.14402023331 |           | 1 |
      | 0.2  | 0.0  | float_power | 1.0              |           | 1 |
      | -0.2 | 0.0  | float_power | 1.0              |           | 1 |
      | 0.2  | 0.0  | float_power | 1.0              |           | 1 |
      | 64.0 | 0.5  | float_power | 8.0              |           | 1 |
      | 0.0  | 0.0  | float_power | 1.0              |           | 1 |
      
      
    Examples: float_power emits an :error when it doesn't return a number
      | arg1  | arg2 | instruction | result | error_msg                                  | d |
      | -12.8 | 3.1  | float_power |        | NaN: result of float_power was not a float | 0 |
      | -64.0 | 0.5  | float_power |        | NaN: result of float_power was not a float | 0 |

    Examples: float_power emits an :error when it returns Infinity
      | arg1    | arg2         | instruction | result | error_msg                                  | d |
      | 99999.0 | 9999999999.0 | float_power |        | NaN: result of float_power was not a float | 0 |
      
