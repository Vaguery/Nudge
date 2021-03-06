Feature: float_divide instruction
  In order to describe and manipulate machine-precision numerical variables
  As a modeler
  I want a suite of :float Nudge arithmetic instructions
  
  Scenario Outline: float_divide
    Given I have pushed "<arg1>" onto the :float stack
    And I have pushed "<arg2>" onto the :float stack
    When I execute the Nudge instruction "<instruction>"
    Then something close to "<result>" should be in position -1 of the :float stack
    And the top :error should include "<error_msg>"
    And stack :float should have depth <d>
      
      
    Examples: float_divide
      | arg1 | arg2 | instruction  | result | error_msg | d |
      | 8.1  | 0.9  | float_divide | 9.0    |           | 1 |
      | 1.0  | 8.0  | float_divide | 0.125  |           | 1 |
      | -2.0 | 2.0  | float_divide | -1.0   |           | 1 |
      | 40.8 | -8.0 | float_divide | -5.1   |           | 1 |
      | 40.8 | 8.0  | float_divide | 5.1    |           | 1 |
      | 0.0  | 8.0  | float_divide | 0.0    |           | 1 |
      | -0.0 | 8.0  | float_divide | 0.0    |           | 1 |
      
    Examples: float_divide emits an :error for dividing by 0
      | arg1 | arg2 | instruction  | result | error_msg      | d |
      | 6.0  | 0.0  | float_divide |        | DivisionByZero | 0 |
      | 0.0  | 0.0  | float_divide |        | DivisionByZero | 0 |
      | -0.0 | 0.0  | float_divide |        | DivisionByZero | 0 |
      | 0.0  | -0.0 | float_divide |        | DivisionByZero | 0 |

    Examples: float_modulo emits an :error when it produces an Infinite answer
      | arg1      | arg2    | instruction  | result | error_msg | d |
      | 5.9e+265  | 1.0e-89 | float_divide |        | NaN       | 0 |
      | -5.9e+265 | 1.0e-89 | float_divide |        | NaN       | 0 |
