Feature: float_equal instruction
  In order to compare values on the float stack
  As a modeler
  I want Nudge to include the float_equal instruction
  
  
  Scenario Outline: float_equal? instruction
    Given I have pushed "<arg1>" onto the :<stack> stack
    And I have pushed "<arg2>" onto the :<stack> stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be on top of the bool stack
    And stack :<stack> should have depth <depth>
    
    
    
    Examples: float_equal_q
    | arg1 | stack | arg2 | stack | instruction  | result | stack | depth |
    | 3.3  | float | 3.3  | float | float_equal? | true   | float | 0     |
    | 3.3  | float | 7.77 | float | float_equal? | false  | float | 0     |
    | 0.0  | float | -0.0 | float | float_equal? | true   | float | 0     |
