Feature: *_flush instruction
  In order to throw stuff away
  As a modeler
  I want to be able to remove everything from any given stack
  
  Scenario Outline: *_flush instructions
    Given I have pushed "<arg1>" onto the :<stack> stack
    Given I have pushed "<arg2>" onto the :<stack> stack
    Given I have pushed "<arg3>" onto the :<stack> stack
    When I execute the Nudge instruction "<inst>"
    Then stack :<stack> should have depth 0
    
    Examples:
    | arg1  | arg2  | arg3  | stack      | inst             |
    | 1     | 2     | 3     | int        | int_flush        |
    | 1.0   | 2.0   | 3.0   | float      | float_flush      |
    | true  | false | true  | bool       | bool_flush       |
    | ref x | ref y | ref z | code       | code_flush       |
    | ref a | ref b | ref c | exec       | exec_flush       |
    | 0.1   | 0.2   | 0.3   | proportion | proportion_flush |
    | x     | y     | z     | name       | name_flush       |
    
