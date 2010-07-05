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
      

    Examples: int_divide uses Knuth divmod algorithm
    | arg1 | s1  | arg2 | s2  | inst       | result | pos | s3  | s4  | depth | error |
    | 8    | int | 2    | int | int_divide | 4      | 0   | int | int | 1     |       |
    | 12   | int | -3   | int | int_divide | -4     | 0   | int | int | 1     |       |
    | -20  | int | 4    | int | int_divide | -5     | 0   | int | int | 1     |       |
    | -40  | int | -8   | int | int_divide | 5      | 0   | int | int | 1     |       |
    | 10   | int | 6    | int | int_divide | 1      | 0   | int | int | 1     |       |
    | 6    | int | 10   | int | int_divide | 0      | 0   | int | int | 1     |       |
    | -3   | int | 5    | int | int_divide | -1     | 0   | int | int | 1     |       |
    | 5    | int | -3   | int | int_divide | -2     | 0   | int | int | 1     |       |
    | 0    | int | 1    | int | int_divide | 0      | 0   | int | int | 1     |       |
    
    Examples: int_divide emits an :error for dividing by 0
    | arg1 | s1  | arg2 | s2  | inst       | result | pos | s3  | s4  | depth | error                                     |
    | 1    | int | -0   | int | int_divide |        | 0   | int | int | 0     | DivisionByZero: cannot divide an int by 0 |
    | 0    | int | 0    | int | int_divide |        | 0   | int | int | 0     | DivisionByZero: cannot divide an int by 0 |
      
      
    Examples: int_max
    | arg1 | s1  | arg2 | s2  | inst    | result | pos | s3  | s4  | depth | error |
    | 12   | int | 1    | int | int_max | 12     | 0   | int | int | 1     |       |
    | 1    | int | 12   | int | int_max | 12     | 0   | int | int | 1     |       |
    | -2   | int | 2    | int | int_max | 2      | 0   | int | int | 1     |       |
    | 3    | int | 3    | int | int_max | 3      | 0   | int | int | 1     |       |


    Examples: int_min
    | arg1 | s1  | arg2 | s2  | inst    | result | pos | s3  | s4  | depth | error |
    | 12   | int | 1    | int | int_min | 1      | 0   | int | int | 1     |       |
    | 1    | int | 12   | int | int_min | 1      | 0   | int | int | 1     |       |
    | -2   | int | 2    | int | int_min | -2     | 0   | int | int | 1     |       |
    | 3    | int | 3    | int | int_min | 3      | 0   | int | int | 1     |       |
      
      
    Examples: int_modulo uses Knuth divmod algorithm
    | arg1 | s1  | arg2 | s2  | inst       | result | pos | s3  | s4  | depth | error |
    | 9    | int | 3    | int | int_modulo | 0      | 0   | int | int | 1     |       |
    | 9    | int | -3   | int | int_modulo | 0      | 0   | int | int | 1     |       |
    | -9   | int | -3   | int | int_modulo | 0      | 0   | int | int | 1     |       |
    | -9   | int | 3    | int | int_modulo | 0      | 0   | int | int | 1     |       |
    | 8    | int | 3    | int | int_modulo | 2      | 0   | int | int | 1     |       |
    | 8    | int | -3   | int | int_modulo | -1     | 0   | int | int | 1     |       |
    | -8   | int | -3   | int | int_modulo | -2     | 0   | int | int | 1     |       |
    | -8   | int | 3    | int | int_modulo | 1      | 0   | int | int | 1     |       |
    | 3    | int | 7    | int | int_modulo | 3      | 0   | int | int | 1     |       |
    | 3    | int | -7   | int | int_modulo | -4     | 0   | int | int | 1     |       |
    | -3   | int | -7   | int | int_modulo | -3     | 0   | int | int | 1     |       |
    | -3   | int | 7    | int | int_modulo | 4      | 0   | int | int | 1     |       |
      
      
    Examples: int_modulo emits an :error for dividing by 0
    | arg1 | s1  | arg2 | s2  | inst       | result | pos | s3  | s4  | depth | error                                          |
    | 3    | int | 0    | int | int_modulo |        | 0   | int | int | 0     | DivisionByZero: cannot perform int modulo zero |
    | 0    | int | 0    | int | int_modulo |        | 0   | int | int | 0     | DivisionByZero: cannot perform int modulo zero |
    | 0    | int | -0   | int | int_modulo |        | 0   | int | int | 0     | DivisionByZero: cannot perform int modulo zero |
      
      
    Examples: int_multiply
    | arg1 | s1  | arg2 | s2  | inst         | result | pos | s3  | s4  | depth | error |
    | 3    | int | 4    | int | int_multiply | 12     | 0   | int | int | 1     |       |
    | 0    | int | 3    | int | int_multiply | 0      | 0   | int | int | 1     |       |
    | -2   | int | 16   | int | int_multiply | -32    | 0   | int | int | 1     |       |
    | -2   | int | -4   | int | int_multiply | 8      | 0   | int | int | 1     |       |
    | 1    | int | -4   | int | int_multiply | -4     | 0   | int | int | 1     |       |
      
      
    Examples: int_power
    | arg1 | s1  | arg2 | s2  | inst      | result | pos | s3  | s4  | depth | error |
    | 3    | int | 3    | int | int_power | 27     | 0   | int | int | 1     |       |
    | 3    | int | 1    | int | int_power | 3      | 0   | int | int | 1     |       |
    | 3    | int | 0    | int | int_power | 1      | 0   | int | int | 1     |       |
    | 3    | int | -3   | int | int_power | 0      | 0   | int | int | 1     |       |
    | -4   | int | 7    | int | int_power | -16384 | 0   | int | int | 1     |       |
    | -4   | int | -2   | int | int_power | 0      | 0   | int | int | 1     |       |
    | -4   | int | -2   | int | int_power | 0      | 0   | int | int | 1     |       |
      
    Examples: int_power emits an :error for Infinity results
    | arg1  | s1  | arg2    | s2  | inst      | result | pos | s3  | s4  | depth | error                                 |
    | 77777 | int | 9999999 | int | int_power |        | 0   | int | int | 0     | NaN: result of int power was Infinity |
      
      
    Examples: int_subtract
    | arg1 | s1  | arg2 | s2  | inst         | result | pos | s3  | s4  | depth | error |
    | 3    | int | 4    | int | int_subtract | -1     | 0   | int | int | 1     |       |
    | 5    | int | 3    | int | int_subtract | 2      | 0   | int | int | 1     |       |
    | -2   | int | -3   | int | int_subtract | 1      | 0   | int | int | 1     |       |
    | -3   | int | -2   | int | int_subtract | -1     | 0   | int | int | 1     |       |
    | -3   | int | 0    | int | int_subtract | -3     | 0   | int | int | 1     |       |
      
      
