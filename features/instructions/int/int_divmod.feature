Feature: Integer arity-2 math instructions
  In order to save some trouble and kill two birds with one stone
  As a modeler
  I want a Nudge divmod instruction that returns both results from the Knuth algorithm
  
  Scenario Outline: int_divmod instruction
    Given I have pushed "<arg1>" onto the :<s1> stack
    And I have pushed "<arg2>" onto the :<s1> stack
    When I execute the Nudge instruction "<inst>"
    Then "<r1>" should be in position <pos1> of the :<out> stack
    And "<r2>" should be in position <pos2> of the :<out> stack
    And stack :<out> should have depth <depth>
    And the top :error should include "<error>"

      
      
    Examples: int_divmod uses Knuth divmod algorithm
    | arg1 | s1  | arg2 | inst       | r1 | pos1 | out | r2 | pos2 | depth | error |
    | 9    | int | 3    | int_divmod | 3  | 0    | int | 0  | 1    | 2     |       |
    | 9    | int | -3   | int_divmod | -3 | 0    | int | 0  | 1    | 2     |       |
    | -9   | int | 3    | int_divmod | -3 | 0    | int | 0  | 1    | 2     |       |
    | 8    | int | 3    | int_divmod | 2  | 0    | int | 2  | 1    | 2     |       |
    | 8    | int | -3   | int_divmod | -3 | 0    | int | -1 | 1    | 2     |       |
    | -8   | int | 3    | int_divmod | -3 | 0    | int | 1  | 1    | 2     |       |
    | -8   | int | -3   | int_divmod | 2  | 0    | int | -2 | 1    | 2     |       |
    | 3    | int | 7    | int_divmod | 0  | 0    | int | 3  | 1    | 2     |       |
    | 3    | int | -7   | int_divmod | -1 | 0    | int | -4 | 1    | 2     |       |
    | -3   | int | -7   | int_divmod | 0  | 0    | int | -3 | 1    | 2     |       |
    | -3   | int | 7    | int_divmod | -1 | 0    | int | 4  | 1    | 2     |       |
      
      
    Examples: int_divmod emits an :error for dividing by 0
    | arg1 | s1  | arg2 | inst       | r1 | pos1 | out | r2 | pos2 | depth | error                                          |
    | 3    | int | 0    | int_divmod |    | 0    | int |    | 1    | 0     | DivisionByZero: cannot perform int modulo zero |
    | 0    | int | 0    | int_divmod |    | 0    | int |    | 1    | 0     | DivisionByZero: cannot perform int modulo zero |
    | 0    | int | -0   | int_divmod |    | 0    | int |    | 1    | 0     | DivisionByZero: cannot perform int modulo zero |
