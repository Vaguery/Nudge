Feature: Integer arity-2 math instructions
  In order to describe and manipulate integer numerical variables
  As a modeler
  I want a suite of :int Nudge arithmetic instructions
  
  Scenario: basic arity-2 instructions
    Given I have placed "<arg1>" on the :int stack
    And I have placed "<arg2>" on top of that
    When I execute the Nudge code "<instruction>"
    Then the value "<result>" should be on top of the :int stack
    And a message "<error_msg>" should be on the :error stack
    And the arguments should not remain on :int
    
    Scenario Outline: int_add
      | arg1   | arg2   | instruction | result | error_msg |
      |    6   |    5   | do int_add  |   11   | |
      |   -9   |    4   | do int_add  |   -5   | |
      |   -3   |  -11   | do int_add  |  -14   | |

    Scenario Outline: int_divide
      | arg1   | arg2  | instruction    | result  | error_msg |
      |   8    |    2  | do int_divide  |   4     | |
      |  12    |   -3  | do int_divide  |  -4     | |
      | -20    |    4  | do int_divide  |  -5     | |
      | -40    |   -8  | do int_divide  |   5     | |
      |  10    |    6  | do int_divide  |   1     | |
      |   6    |   10  | do int_divide  |   0     | |
      |  -3    |    5  | do int_divide  |   0     | |
      |   5    |   -3  | do int_divide  |  -1     | |
      |   0    |    1  | do int_divide  |   0     | |
      |   1    |   -0  | do int_divide  |         | "int_divide cannot divide by 0" |
      |   0    |    0  | do int_divide  |         | "int_divide cannot divide by 0" |
