#encoding: utf-8
Feature: Value equality
  In order to compare values on any stack
  As a modeler
  I want Nudge to include a suite of [stack]_equal_q instructions
  
  
  Scenario Outline: name_equal? instruction
    Given I have pushed "<arg1>" onto the :<stack> stack
    And I have pushed "<arg2>" onto the :<stack> stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be on top of the bool stack
    And stack :<stack> should have depth <depth>
    
    
    Examples: name_equal?
    | arg1 | stack | arg2 | stack | instruction | result | stack | depth |
    | x1   | name  | x1   | name  | name_equal? | true   | name  | 0     |
    | x11  | name  | x1   | name  | name_equal? | false  | name  | 0     |
