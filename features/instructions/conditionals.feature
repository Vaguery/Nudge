Feature: Conditional instructions
  In order to search for branching algorithms
  As a modeler
  I want the Nudge language to include a set of conditional instructions "x_if"
  
  Scenario Outline: x_if
    Given I have pushed "<arg1>" onto the :<stack1> stack
    And I have pushed "<arg2>" onto the :<stack2> stack
    And I have pushed "<t_or_f>" onto the bool stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be in position <posn> of the :<out_stack> stack
    And that stack's depth should be <depth>
    
    Examples: float_if
    | arg1 | stack1 | arg2 | stack2 | t_or_f | instruction | result | posn | out_stack | depth |
    | 3.3  | float  | 7.77 | float  | true   | float_if    | 3.3    | 0    | float     | 1     |
    | 3.3  | float  | 7.77 | float  | false  | float_if    | 7.77   | 0    | float     | 1     |
    
    
    Examples: int_if
    | arg1 | stack1 | arg2 | stack2 | t_or_f | instruction | result | posn | out_stack | depth |
    | 1    | int    | 222  | int    | true   | int_if      | 1      | 0    | int       | 1     |
    | 1    | int    | 222  | int    | false  | int_if      | 222    | 0    | int       | 1     |
    
    
    Examples: code_if
    | arg1  | stack1 | arg2    | stack2 | t_or_f | instruction | result  | posn | out_stack | depth |
    | ref x | code   | do a_bc | code   | true   | code_if     | ref x   | 0    | code      | 1     |
    | ref x | code   | do a_bc | code   | false  | code_if     | do a_bc | 0    | code      | 1     |
    
    
    Examples: exec_if (note this is pushing strings, though it shouldn't)
    | arg1  | stack1 | arg2  | stack2 | t_or_f | instruction | result | posn | out_stack | depth |
    | ref a | exec   | ref b | exec   | true   | exec_if     | ref a  | 0    | exec      | 1     |
    | ref a | exec   | ref b | exec   | false  | exec_if     | ref b  | 0    | exec      | 1     |
    
    
    Examples: proportion_if
    | arg1 | stack1     | arg2   | stack2     | t_or_f | instruction   | result | posn | out_stack  | depth |
    | 0.1  | proportion | 0.9999 | proportion | true   | proportion_if | 0.1    | 0    | proportion | 1     |
    | 0.1  | proportion | 0.9999 | proportion | false  | proportion_if | 0.9999 | 0    | proportion | 1     |
    
    
    Examples: name_if
    | arg1 | stack1 | arg2 | stack2 | t_or_f | instruction | result | posn | out_stack | depth |
    | x1   | name   | y2   | name   | true   | name_if     | x1     | 0    | name      | 1     |
    | x1   | name   | y2   | name   | false  | name_if     | y2     | 0    | name      | 1     |
    