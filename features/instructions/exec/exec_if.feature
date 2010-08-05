Feature: exec_if instruction
  In order to search for branching algorithms
  As a modeler
  I want the Nudge language to include a set of conditional instructions "x_if"
  
  Scenario Outline: exec_if
    Given I have pushed "<arg1>" onto the :<stack1> stack
    And I have pushed "<arg2>" onto the :<stack2> stack
    And I have pushed "<t_or_f>" onto the bool stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be in position <posn> of the :<out_stack> stack
    And that stack's depth should be <depth>
    
    
    Examples: exec_if
    | arg1  | stack1 | arg2  | stack2 | t_or_f | instruction | result | posn | out_stack | depth |
    | ref a | exec   | ref b | exec   | true   | exec_if     | ref a  | 0    | exec      | 1     |
    | ref a | exec   | ref b | exec   | false  | exec_if     | ref b  | 0    | exec      | 1     |
    
