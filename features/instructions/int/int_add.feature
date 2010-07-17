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
    
    Examples: int_add
    | arg1 | s1  | arg2 | s2  | inst    | result | pos | s3  | s4  | depth |
    | 6    | int | 5    | int | int_add | 11     | 0   | int | int | 1     |
    | -9   | int | 4    | int | int_add | -5     | 0   | int | int | 1     |
    | -3   | int | -11  | int | int_add | -14    | 0   | int | int | 1     |
    | 0    | int | -11  | int | int_add | -11    | 0   | int | int | 1     |
