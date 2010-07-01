Feature: bool_and instruction
  In order to describe and manipulate discrete logical variables
  As a modeler
  I want a suite of Boolean logic Nudge instructions
  
  Scenario Outline: bool_and
    Given I have pushed "<arg1>" onto the :<stack1> stack
    And I have pushed "<arg2>" onto the :<stack2> stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be in position <posn> of the :<out_stack> stack
    And that stack's depth should be <final_depth>
    
    Examples: bool_and
      | arg1  | stack1 | arg2  | stack2 | instruction | result | posn | out_stack | final_depth |
      | true  | bool   | true  | bool   | bool_and    | true   | 0    | bool      | 1           |
      | true  | bool   | false | bool   | bool_and    | false  | 0    | bool      | 1           |
      | false | bool   | true  | bool   | bool_and    | false  | 0    | bool      | 1           |
      | false | bool   | false | bool   | bool_and    | false  | 0    | bool      | 1           |
