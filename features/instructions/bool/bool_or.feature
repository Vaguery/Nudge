Feature: bool_or instruction
  In order to describe and manipulate discrete logical variables
  As a modeler
  I want a suite of Boolean logic Nudge instructions
  
  Scenario Outline: basic arity-2 instructions
    Given I have pushed "<arg1>" onto the :<stack1> stack
    And I have pushed "<arg2>" onto the :<stack2> stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be in position <posn> of the :<out_stack> stack
    And stack :<out_stack> should have depth <final_depth>
    
    Examples: bool_or
      | arg1  | stack1 | arg2  | stack2 | instruction | result | posn | out_stack | final_depth |
      | true  | bool   | true  | bool   | bool_or     | true   | 0    | bool      | 1           |
      | true  | bool   | false | bool   | bool_or     | true   | 0    | bool      | 1           |
      | false | bool   | true  | bool   | bool_or     | true   | 0    | bool      | 1           |
      | false | bool   | false | bool   | bool_or     | false  | 0    | bool      | 1           |
