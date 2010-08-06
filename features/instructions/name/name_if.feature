Feature: name_if instruction
  In order to search for branching algorithms
  As a modeler
  I want the Nudge language to include a set of conditional instructions "x_if"
  
  Scenario Outline: name_if
    Given I have pushed "<arg1>" onto the :<stack1> stack
    And I have pushed "<arg2>" onto the :<stack2> stack
    And I have pushed "<t_or_f>" onto the bool stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be in position <posn> of the :<out_stack> stack
    And stack :<out_stack> should have depth <depth>
    
    
    Examples: name_if
    | arg1 | stack1 | arg2 | stack2 | t_or_f | instruction | result | posn | out_stack | depth |
    | x1   | name   | y2   | name   | true   | name_if     | x1     | 0    | name      | 1     |
    | x1   | name   | y2   | name   | false  | name_if     | y2     | 0    | name      | 1     |
