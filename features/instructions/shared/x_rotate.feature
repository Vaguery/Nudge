Feature: *_rotate instruction
  In order to rearrange things in algorithms
  As a modeler
  I want to be able to shift items around on any given stack
  
  Scenario Outline: *_rotate instructions
    Given I have pushed "<arg1>" onto the :<stack> stack
    And I have pushed "<arg2>" onto the :<stack> stack
    And I have pushed "<arg3>" onto the :<stack> stack
    When I execute the Nudge instruction "<inst>"
    Then stack :<stack> should have depth 3
    And "<arg1>" should be in position -1 of the :<stack> stack
    And "<arg3>" should be in position -2 of the :<stack> stack
    And "<arg2>" should be in position -3 of the :<stack> stack
    
    Examples:
    | arg1  | arg2  | arg3  | stack      | inst              |
    | 1     | 2     | 3     | int        | int_rotate        |
    | 1.0   | 2.0   | 3.0   | float      | float_rotate      |
    | true  | false | true  | bool       | bool_rotate       |
    | ref x | ref y | ref z | code       | code_rotate       |
    | ref a | ref b | ref c | exec       | exec_rotate       |
    | 0.1   | 0.2   | 0.3   | proportion | proportion_rotate |
    | x     | y     | z     | name       | name_rotate       |
    
