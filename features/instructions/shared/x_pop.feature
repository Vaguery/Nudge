Feature: *_pop instruction
  In order to throw stuff away
  As a modeler
  I want to be able to remove items from any given stack
  
  Scenario Outline: *_pop instructions
    Given I have pushed "<arg1>" onto the :<stack> stack
    Given I have pushed "<arg2>" onto the :<stack> stack
    Given I have pushed "<arg3>" onto the :<stack> stack
    When I execute the Nudge instruction "<inst>"
    Then stack :<stack> should have depth 2
    And "<arg2>" should be in position -1 of the :<stack> stack
    
    Examples:
    | arg1  | arg2  | arg3  | stack      | inst           |
    | 1     | 2     | 3     | int        | int_pop        |
    | 1.0   | 2.0   | 3.0   | float      | float_pop      |
    | true  | false | true  | bool       | bool_pop       |
    | ref x | ref y | ref z | code       | code_pop       |
    | ref a | ref b | ref c | exec       | exec_pop       |
    | 0.1   | 0.2   | 0.3   | proportion | proportion_pop |
    | x     | y     | z     | name       | name_pop       |
    
