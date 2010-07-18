Feature: Value equality
  In order to compare values on the :bool stack
  As a modeler
  I want Nudge to include the bool_equal? instruction
  
  
  Scenario Outline: x_equal_q
    Given I have pushed "<arg1>" onto the :<stack> stack
    And I have pushed "<arg2>" onto the :<stack> stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be on top of the bool stack
    And stack :<stack> should have depth <depth>
    
    
    Examples: bool_equal_q
    | arg1 | stack | arg2  | stack | instruction | result | stack | depth |
    | true | bool  | true  | bool  | bool_equal? | true   | bool  | 1     |
    | true | bool  | false | bool  | bool_equal? | false  | bool  | 1     |
