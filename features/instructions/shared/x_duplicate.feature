Feature: *_duplicate instruction
  In order to make new copies of stuff
  As a modeler
  I want to be able to duploicate items from any given stack
  
  Scenario Outline: *_duplicate instructions
    Given I have pushed "<arg1>" onto the :<stack> stack
    Given I have pushed "<arg2>" onto the :<stack> stack
    When I execute the Nudge instruction "<inst>"
    Then stack :<stack> should have depth 3
    And "<arg2>" should be in position -1 of the :<stack> stack
    And "<arg2>" should be in position -2 of the :<stack> stack
    And "<arg1>" should be in position -3 of the :<stack> stack
    
    Examples:
    | arg1  | arg2  |  stack      | inst                 |
    | 1     | 2     |  int        | int_duplicate        |
    | 1.0   | 2.0   |  float      | float_duplicate      |
    | true  | false |  bool       | bool_duplicate       |
    | ref x | ref y |  code       | code_duplicate       |
    | ref a | ref b |  exec       | exec_duplicate       |
    | 0.1   | 0.2   |  proportion | proportion_duplicate |
    | x     | y     |  name       | name_duplicate       |
    
