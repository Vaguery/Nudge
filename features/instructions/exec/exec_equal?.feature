#encoding: utf-8
Feature: Value equality
  In order to compare values on any stack
  As a modeler
  I want Nudge to include a suite of [stack]_equal_q instructions
  
  
  Scenario Outline: exec_equal? instruction
    Given I have pushed "<arg1>" onto the :<stack> stack
    And I have pushed "<arg2>" onto the :<stack> stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be on top of the bool stack
    And stack :<stack> should have depth <depth>
    
    
    Examples: exec_equal? (compares these trees, not strings)
    | arg1                 | stack | arg2                 | stack | instruction | result | stack | depth |
    | ref x                | exec  | ref x                | exec  | exec_equal? | true   | exec  | 0     |
    | do foo               | exec  | do foo               | exec  | exec_equal? | true   | exec  | 0     |
    | value «int»\n«int» 8 | exec  | value «int»\n«int» 8 | exec  | exec_equal? | true   | exec  | 0     |
    | block {do bar}       | exec  | block\t{\n do bar\n} | exec  | exec_equal? | true   | exec  | 0     |
    | ref x                | exec  | ref y                | exec  | exec_equal? | false  | exec  | 0     |
    | do foo               | exec  | do bar               | exec  | exec_equal? | false  | exec  | 0     |
    | value «int»\n«int» 9 | exec  | value «int»\n«int» 8 | exec  | exec_equal? | false  | exec  | 0     |
    | block {do bar}       | exec  | block\t{\n  do  foo} | exec  | exec_equal? | false  | exec  | 0     |
