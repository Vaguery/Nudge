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
