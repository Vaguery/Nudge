#encoding: utf-8
Feature: Value equality
  In order to compare values on any stack
  As a modeler
  I want Nudge to include a suite of [stack]_equal_q instructions
  
  
  Scenario Outline: x_equal_q
    Given I have pushed "<arg1>" onto the :<stack> stack
    And I have pushed "<arg2>" onto the :<stack> stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be on top of the bool stack
    And stack :<stack> should have depth <depth>
    
    Examples: code_equal? (compares parsed code, not strings)
    | arg1                | stack | arg2                   | stack | instruction | result | stack | depth |
    | ref x               | code  | ref x                  | code  | code_equal? | true   | code  | 0     |
    | ref \t\n  x         | code  | ref x                  | code  | code_equal? | true   | code  | 0     |
    | do    foo           | code  | do foo                 | code  | code_equal? | true   | code  | 0     |
    | value «int»\n«int»8 | code  | value\t«int»\n«int» 8  | code  | code_equal? | true   | code  | 0     |
    | block {do bar}      | code  | block\t{\n  do  bar\n} | code  | code_equal? | true   | code  | 0     |
    | block {}            | code  | block {block {}}       | code  | code_equal? | false  | code  | 0     |
    
    
    Examples: code_equal_q is always false for unparseable code
    | arg1     | stack | arg2            | stack | instruction | result | stack | depth |
    | not code | code  | neither is this | code  | code_equal? | false  | code  | 0     |
    | block {} | code  | busted          | code  | code_equal? | false  | code  | 0     |
