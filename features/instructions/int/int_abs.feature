Feature: Integer arity-1 instructions
  In order to describe and manipulate integer variables
  As a modeler
  I want a suite of Integer arithmetic Nudge instructions
  
  Scenario Outline: basic arity-1 instructions
    Given I have pushed "<arg1>" onto the :int stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be in position <posn> of the :<result_stack> stack
    And stack :<result_stack> should have depth <depth>    
    
    
    Examples: int_abs
      | arg1 | instruction | result | posn | result_stack | depth |
      | 13   | int_abs     | 13     | 0    | int          | 1     |
      | -13  | int_abs     | 13     | 0    | int          | 1     |
      | 0    | int_abs     | 0      | 0    | int          | 1     |
      | -0   | int_abs     | 0      | 0    | int          | 1     |
