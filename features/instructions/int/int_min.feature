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


    Examples: int_min
    | arg1 | s1  | arg2 | s2  | inst    | result | pos | s3  | s4  | depth | 
    | 12   | int | 1    | int | int_min | 1      | 0   | int | int | 1     | 
    | 1    | int | 12   | int | int_min | 1      | 0   | int | int | 1     | 
    | -2   | int | 2    | int | int_min | -2     | 0   | int | int | 1     | 
    | 3    | int | 3    | int | int_min | 3      | 0   | int | int | 1     | 
