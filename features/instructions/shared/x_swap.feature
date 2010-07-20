Feature: *_swap instruction
  In order to implement simple algorithms
  As a modeler
  I want to be able to swap the two top items on any given stack
  
  Scenario Outline: *_swap instructions
    Given I have pushed "<arg1>" onto the :<stack> stack
    Given I have pushed "<arg2>" onto the :<stack> stack
    Given I have pushed "<arg3>" onto the :<stack> stack
    When I execute the Nudge instruction "<inst>"
    Then stack :<stack> should have depth 3
    And "<arg2>" should be in position -1 of the :<stack> stack
    And "<arg3>" should be in position -2 of the :<stack> stack
    And "<arg1>" should be in position -3 of the :<stack> stack
    
    
    Examples:
    | arg1  | arg2  | arg3  | stack      | inst           |
    | 1     | 2     | 3     | int        | int_swap        |
    | 1.0   | 2.0   | 3.0   | float      | float_swap      |
    | true  | false | true  | bool       | bool_swap       |
    | ref x | ref y | ref z | code       | code_swap       |
    | ref a | ref b | ref c | exec       | exec_swap       |
    | 0.1   | 0.2   | 0.3   | proportion | proportion_swap |
    | x     | y     | z     | name       | name_swap       |
    
