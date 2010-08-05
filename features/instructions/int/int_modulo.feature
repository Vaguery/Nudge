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
