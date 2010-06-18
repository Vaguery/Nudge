Feature: Float arity-2 math instructions
  In order to describe and manipulate machine-precision numerical variables
  As a modeler
  I want a suite of :float Nudge arithmetic instructions
  
  Scenario: basic arity-2 instructions
    Given I have placed "<arg1>" on the :float stack
    And I have placed "<arg2>" on top of that
    When I execute the Nudge code "<instruction>"
    Then a value very close to "<result>" should be on top of the :float stack
    And a message "<error_msg>" should be on the :error stack
    And the arguments should not remain on :float
    
    Scenario Outline: float_add
      | arg1   | arg2   | instruction   | result | error_msg |
      |  12.1  | -12.0  | do float_add  |  0.1   | |
      |   0.0  |   3.3  | do float_add  |  3.3   | |
      |  -2.0  |  -2.0  | do float_add  | -4.0   | |
      
      
    Scenario Outline: float_divide
      | arg1   | arg2  | instruction      | result  | error_msg |
      |   8.1  |   0.9 | do float_divide  |   9.0   | |
      |   1.0  |   8.0 | do float_divide  |   0.125 | |
      |  -2.0  |   2.0 | do float_divide  |  -1.0   | |
      |  40.8  |  -8.0 | do float_divide  |  -5.1   | |
      |  40.8  |   8.0 | do float_divide  |   5.1   | |
      |   0.0  |   8.0 | do float_divide  |   0.0   | |
      |  -0.0  |   8.0 | do float_divide  |   0.0   | |
      |   6.0  |   0.0 | do float_divide  |         | "float_divide cannot divide by 0.0" |
      |   0.0  |   0.0 | do float_divide  |         | "float_divide cannot divide by 0.0" |
      |  -0.0  |   0.0 | do float_divide  |         | "float_divide cannot divide by 0.0" |
      |   0.0  |  -0.0 | do float_divide  |         | "float_divide cannot divide by 0.0" |
      
      
    Scenario Outline: float_max
      | arg1  | arg2  | instruction   | result | error_msg |
      |  12.0 |   1.0 | do float_max  |  12.0  | |
      |   1.0 |  12.0 | do float_max  |  12.0  | |
      |  -2.0 |   2.0 | do float_max  |   2.0  | |
      |   3.0 |   3.0 | do float_max  |   3.0  | |
      
      
    Scenario Outline: float_min
      | arg1  | arg2  | instruction   | result | error_msg |
      |  12.0 |   1.0 | do float_min  |   1.0  | |
      |   1.0 |  12.0 | do float_min  |   1.0  | |
      |  -2.0 |   2.0 | do float_min  |  -2.0  | |
      |   3.0 |   3.0 | do float_min  |   3.0  | |
      
      
    Scenario Outline: float_modulo
      | arg1  | arg2  | instruction      | result | error_msg |
      |  3.3  |  1.0  | do float_modulo  |  0.3   | |
      | -3.3  |  1.0  | do float_modulo  |  0.7   | |
      |  3.3  | -1.0  | do float_modulo  | -0.7   | |
      |  3.3  |  3.3  | do float_modulo  |  0.0   | |
      |  6.6  |  3.3  | do float_modulo  |  0.0   | |
      |  3.3  |  1.0  | do float_modulo  |  0.3   | |
      |  1.1  |  6.7  | do float_modulo  |  1.1   | |
      | -1.1  |  6.7  | do float_modulo  |  5.6   | |
      | -1.1  | -6.7  | do float_modulo  | -1.1   | |
      |  2.2  |  0.0  | do float_modulo  |        | "float_modulo attempted modulo 0.0" |
      | -2.2  |  0.0  | do float_modulo  |        | "float_modulo attempted modulo 0.0" |
      |  2.2  | -0.0  | do float_modulo  |        | "float_modulo attempted modulo 0.0" |
      
      
    Scenario Outline: float_multiply
      | arg1 | arg2 | instruction       | result | error_msg |
      |  3.0 |  4.1 | do float_multiply |  12.3  | |
      |  0.0 |  3.3 | do float_multiply |   0.0  | |
      | -2.5 | 16.0 | do float_multiply | -40.0  | |
      | -2.5 | -4.0 | do float_multiply |  10.0  | |
      
      
    Scenario Outline: float_power
      | arg1  | arg2  | instruction     | result | error_msg |
      |  0.2  |  1.0  | do float_power  |  0.2   | |
      |  0.2  |  2.0  | do float_power  |  0.04  | |
      | -0.2  |  2.0  | do float_power  |  0.04  | |
      | 12.8  |  3.1  | do float_power  |  2706.14402023331    | |
      |-12.8  |  3.1  | do float_power  |  0.0   | "float_power did not return a float" |
      |  0.2  |  0.0  | do float_power  |  1.0   | |
      | -0.2  |  0.0  | do float_power  |  1.0   | |
      |  0.2  |  0.0  | do float_power  |  1.0   | |
      | 64.0  |  0.5  | do float_power  |  8.0   | |
      |-64.0  |  0.5  | do float_power  |        | "float_power did not return a float" |
      |  0.0  |  0.0  | do float_power  |  1.0   | |
      
      
    Scenario Outline: float_subtract
      | arg1 | arg2 | instruction       | result | error_msg |
      |  3.0 |  4.1 | do float_subtract |  -1.1  | |
      |  5.6 |  3.3 | do float_subtract |   2.3  | |
      | -2.0 | -3.1 | do float_subtract |   1.1  | |
      | -3.1 | -2.0 | do float_subtract |  -1.1  | |
