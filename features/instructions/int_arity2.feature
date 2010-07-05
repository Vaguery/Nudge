Feature: Integer arity-2 math instructions
  In order to describe and manipulate integer numerical variables
  As a modeler
  I want a suite of :int Nudge arithmetic instructions
  
  Scenario Outline: basic arity-2 instructions
    Given I have pushed "<arg1>" onto the :<s1> stack
    And I have pushed "<arg2>" onto the :<s2> stack
    When I execute the Nudge instruction "<inst>"
    Then "<result>" should be in position <pos> of the :<s3> stack
    And stack :<s4> should have depth <depth>
    And the top :error should include "<error>"
    
    Examples: int_add
      | arg1 | s1  | arg2 | s2  | inst    | result | pos | s3  | s4  | depth | error |
      | 6    | int | 5    | int | int_add | 11     | 0   | int | int | 1     |       |
      | -9   | int | 4    | int | int_add | -5     | 0   | int | int | 1     |       |
      | -3   | int | -11  | int | int_add | -14    | 0   | int | int | 1     |       |
      | 0    | int | -11  | int | int_add | -11    | 0   | int | int | 1     |       |
      

    Examples: int_divide
    | arg1 | s1  | arg2 | s2  | inst       | result | pos | s3  | s4  | depth | error                                     |
    | 8    | int | 2    | int | int_divide | 4      | 0   | int | int | 1     |                                           |
    | 12   | int | -3   | int | int_divide | -4     | 0   | int | int | 1     |                                           |
    | -20  | int | 4    | int | int_divide | -5     | 0   | int | int | 1     |                                           |
    | -40  | int | -8   | int | int_divide | 5      | 0   | int | int | 1     |                                           |
    | 10   | int | 6    | int | int_divide | 1      | 0   | int | int | 1     |                                           |
    | 6    | int | 10   | int | int_divide | 0      | 0   | int | int | 1     |                                           |
    | -3   | int | 5    | int | int_divide | -1     | 0   | int | int | 1     |                                           |
    | 5    | int | -3   | int | int_divide | -2     | 0   | int | int | 1     |                                           |
    | 0    | int | 1    | int | int_divide | 0      | 0   | int | int | 1     |                                           |
    | 1    | int | -0   | int | int_divide |        | 0   | int | int | 0     | DivisionByZero: cannot divide an int by 0 |
    | 0    | int | 0    | int | int_divide |        | 0   | int | int | 0     | DivisionByZero: cannot divide an int by 0 |
      
      
    Examples: int_max
      | arg1 | s1  | arg2 | s2  | inst    | result | pos | s3  | s4  | depth | error |
      | 12   | int | 1    | int | int_max | 12     | 0   | int | int | 1     |       |
      | 1    | int | 12   | int | int_max | 12     | 0   | int | int | 1     |       |
      | -2   | int | 2    | int | int_max | 2      | 0   | int | int | 1     |       |
      | 3    | int | 3    | int | int_max | 3      | 0   | int | int | 1     |       |


    Examples: int_min
      | arg1 | arg2 | instruction | result | error_msg |
      |  12  |   1  | do int_min  |   1    | |
      |   1  |  12  | do int_min  |   1    | |
      |  -2  |   2  | do int_min  |  -2    | |
      |   3  |   3  | do int_min  |   3    | |
      
      
    Examples: int_modulo
      | arg1 | arg2 | instruction   | result | error_msg |
      |  9   |   3  | do int_modulo |  0     | |
      |  9   |  -3  | do int_modulo |  0     | |
      | -9   |  -3  | do int_modulo |  0     | |
      | -9   |   3  | do int_modulo |  0     | |
      |  8   |   3  | do int_modulo |  2     | |
      |  8   |  -3  | do int_modulo | -1     | |
      | -8   |  -3  | do int_modulo | -2     | |
      | -8   |   3  | do int_modulo |  1     | |
      |  3   |   7  | do int_modulo |  3     | |
      |  3   |  -7  | do int_modulo | -4     | |
      | -3   |  -7  | do int_modulo | -3     | |
      | -3   |   7  | do int_modulo |  4     | |
      |  3   |   0  | do int_modulo |        | "int_modulo attempted modulo 0" |
      |  0   |   0  | do int_modulo |        | "int_modulo attempted modulo 0" |
      |  0   |  -0  | do int_modulo |        | "int_modulo attempted modulo 0" |
      
      
    Examples: int_multiply
      | arg1 | arg2 | instruction       | result | error_msg |
      |  3   |  4   | do int_multiply   |  12    | |
      |  0   |  3   | do int_multiply   |   0    | |
      | -2   | 16   | do int_multiply   | -32    | |
      | -2   | -4   | do int_multiply   |   8    | |
      |  1   | -4   | do int_multiply   |  -4    | |
      
      
    Examples: int_power
      | arg1  | arg2     | instruction  | result | error_msg |
      |   3   |   3      | do int_power |   27   | |
      |   3   |   1      | do int_power |    3   | |
      |   3   |   0      | do int_power |    1   | |
      |   3   |  -3      | do int_power |    0   | |
      |  -4   |   7      | do int_power | -16384 | |
      |  -4   |  -2      | do int_power |    0   | |
      |  -4   |  -2      | do int_power |    0   | |
      | 77777 | 9999999  | do int_power |        | "int_power did not return a finite integer" |
      
      
    Examples: int_subtract
      | arg1 | arg2 | instruction     | result | error_msg |
      |  3   |  4   | do int_subtract |  -1    | |
      |  5   |  3   | do int_subtract |   2    | |
      | -2   | -3   | do int_subtract |   1    | |
      | -3   | -2   | do int_subtract |  -1    | |
      | -3   |  0   | do int_subtract |  -3    | |
      
      
