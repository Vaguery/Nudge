#encoding: utf-8
Feature: Value equality
  In order to compare values on any stack
  As a modeler
  I want Nudge to include a suite of [stack]_equal_q instructions
  
  
  Scenario Outline: proportion_equal? instruction
    Given I have pushed "<arg1>" onto the :<stack> stack
    And I have pushed "<arg2>" onto the :<stack> stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be on top of the bool stack
    And stack :<stack> should have depth <depth>
    
    
    Examples: proportion_equal_q
    | arg1 | stack      | arg2  | stack      | instruction       | result | stack      | depth |
    | 0.12 | proportion | 0.12  | proportion | proportion_equal? | true   | proportion | 0     |
    | 0.10 | proportion | 0.101 | proportion | proportion_equal? | false  | proportion | 0     |
