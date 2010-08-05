Feature: Integer arity-1 instructions
  In order to describe and manipulate integer variables
  As a modeler
  I want a suite of Integer arithmetic Nudge instructions
  
  Scenario Outline: basic arity-1 instructions
    Given I have pushed "<arg1>" onto the :int stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be in position <posn> of the :<result_stack> stack
    And that stack's depth should be <depth>    
      
      
    Examples: int_negative
    | arg1 | instruction  | result | posn | result_stack | depth |
    | 3    | int_negative | -3     | 0    | int          | 1     |
    | -4   | int_negative | 4      | 0    | int          | 1     |
    | 0    | int_negative | 0      | 0    | int          | 1     |
    | -0   | int_negative | 0      | 0    | int          | 1     |
      
