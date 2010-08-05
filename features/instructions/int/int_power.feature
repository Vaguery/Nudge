Feature: Integer arity-2 math instructions
  In order to describe and manipulate integer numerical variables
  As a modeler
  I want a suite of :int Nudge arithmetic instructions
  
  Scenario Outline: basic arity-2 instructions
    Given I have pushed "<arg1>" onto the :<s1> stack
    And I have pushed "<arg2>" onto the :<s2> stack
    When I execute the Nudge instruction "<inst>"
    Then "<result>" should be in position <pos> of the :<s3> stack
    And no warning message should be produced
    And stack :<s4> should have depth <depth>
    And the top :error should include "<error>"
      
      
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
    | 77777 | int | 9999999 | int | int_power |        | 0   | int | int | 0     | NaN: result of int_power was Infinity |
    
    Examples: int_power emits an :error for dividing by zero results
    | arg1 | s1  | arg2 | s2  | inst      | result | pos | s3  | s4  | depth | error                     |
    | 0    | int | -3   | int | int_power |        | 0   | int | int | 0     | DivisionByZero: int_power |
    
