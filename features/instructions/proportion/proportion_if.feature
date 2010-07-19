Feature: proportion_if instruction
  In order to search for branching algorithms
  As a modeler
  I want the Nudge language to include a set of conditional instructions "x_if"
  
  Scenario Outline: proportion_if
    Given I have pushed "<arg1>" onto the :<stack1> stack
    And I have pushed "<arg2>" onto the :<stack2> stack
    And I have pushed "<t_or_f>" onto the bool stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be in position <posn> of the :<out_stack> stack
    And that stack's depth should be <depth>
    
    
    Examples: proportion_if
    | arg1 | stack1     | arg2   | stack2     | t_or_f | instruction   | result | posn | out_stack  | depth |
    | 0.1  | proportion | 0.9999 | proportion | true   | proportion_if | 0.1    | 0    | proportion | 1     |
    | 0.1  | proportion | 0.9999 | proportion | false  | proportion_if | 0.9999 | 0    | proportion | 1     |
