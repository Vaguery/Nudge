Feature: float_unlimited_power instruction
  In order to make very large and very small floating-point values
  As a modeler
  I want a float_unlimited_power instruction that just implements ** without constraints
  
  Scenario Outline: float_unlimited_power
    Given I have pushed "<arg1>" onto the :float stack
    And I have pushed "<arg2>" onto the :float stack
    When I execute the Nudge instruction "float_unlimited_power"
    Then something close to "<result>" should be in position -1 of the :float stack
    And the top :error should include "<error_msg>"
    And stack :float should have depth <d>
      
      
    Examples: float_unlimited_power
      | arg1 | arg2 | result           | error_msg | d |
      | 0.2  | 1.0  | 0.2              |           | 1 |
      | 0.2  | 2.0  | 0.04             |           | 1 |
      | -0.2 | 2.0  | 0.04             |           | 1 |
      | 12.8 | 3.1  | 2706.14402023331 |           | 1 |
      | 0.2  | 0.0  | 1.0              |           | 1 |
      | -0.2 | 0.0  | 1.0              |           | 1 |
      | 0.2  | 0.0  | 1.0              |           | 1 |
      | 64.0 | 0.5  | 8.0              |           | 1 |
      | 0.0  | 0.0  | 1.0              |           | 1 |
      
      
    Examples: float_unlimited_power emits an :error when it doesn't return a number
      | arg1  | arg2 | result | error_msg | d |
      | -12.8 | 3.1  |        | NaN       | 0 |
      | -64.0 | 0.5  |        | NaN       | 0 |

    Examples: float_unlimited_power emits an :error when it returns Infinity
      | arg1    | arg2         | result | error_msg | d |
      | 99999.0 | 9999999999.0 |        | NaN       | 0 |
      
    Examples: float_unlimited_power emits an :error when it takes a negative exponent of 0.0
      | arg1 | arg2 | result | error_msg | d |
      | 0.0  | -3.0 |        | NaN       | 0 |
      
