Feature: float_modulo instruction
  In order to describe and manipulate machine-precision numerical variables
  As a modeler
  I want a suite of :float Nudge arithmetic instructions
  
  Scenario Outline: float_modulo
    Given I have pushed "<arg1>" onto the :float stack
    And I have pushed "<arg2>" onto the :float stack
    When I execute the Nudge instruction "<instruction>"
    Then something close to "<result>" should be in position -1 of the :float stack
    And the top :error should include "<error_msg>"
    And stack :float should have depth <d>
      
    
    Examples: float_modulo
      | arg1 | arg2 | instruction  | result | error_msg | d |
      | 3.3  | 1.0  | float_modulo | 0.3    |           | 1 |
      | -3.3 | 1.0  | float_modulo | 0.7    |           | 1 |
      | 3.3  | -1.0 | float_modulo | -0.7   |           | 1 |
      | 3.3  | 3.3  | float_modulo | 0.0    |           | 1 |
      | 6.6  | 3.3  | float_modulo | 0.0    |           | 1 |
      | 3.3  | 1.0  | float_modulo | 0.3    |           | 1 |
      | 1.1  | 6.7  | float_modulo | 1.1    |           | 1 |
      | -1.1 | 6.7  | float_modulo | 5.6    |           | 1 |
      | -1.1 | -6.7 | float_modulo | -1.1   |           | 1 |
      
    Examples: float_modulo emits an :error for dividing by 0
      | arg1 | arg2 | instruction  | result | error_msg      | d |
      | 2.2  | 0.0  | float_modulo |        | DivisionByZero | 0 |
      | -2.2 | 0.0  | float_modulo |        | DivisionByZero | 0 |
      | 2.2  | -0.0 | float_modulo |        | DivisionByZero | 0 |
      
    Examples: float_modulo emits an :error when it produces an Infinite answer
      | arg1      | arg2    | instruction  | result | error_msg | d |
      | 5.9e+265  | 1.0e-89 | float_modulo |        | NaN       | 0 |
      | -5.9e+265 | 1.0e-89 | float_modulo |        | NaN       | 0 |
    
