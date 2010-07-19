Feature: code_if instruction
  In order to search for branching algorithms
  As a modeler
  I want the Nudge language to include a set of conditional instructions "x_if"
  
  Scenario Outline: code_if
    Given I have pushed "<arg1>" onto the :<stack1> stack
    And I have pushed "<arg2>" onto the :<stack2> stack
    And I have pushed "<t_or_f>" onto the bool stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be in position <posn> of the :<out_stack> stack
    And that stack's depth should be <depth>
    
    
    
    Examples: code_if
    | arg1  | stack1 | arg2    | stack2 | t_or_f | instruction | result  | posn | out_stack | depth |
    | ref x | code   | do a_bc | code   | true   | code_if     | ref x   | 0    | code      | 1     |
    | ref x | code   | do a_bc | code   | false  | code_if     | do a_bc | 0    | code      | 1     |
