Feature: *_depth instruction
  In order to plan ahead in Nudge algorithms
  As a modeler
  I want to be able to count items on any given stack
  
  Scenario Outline: *_depth instructions
    Given I have pushed "<arg1>" onto the :<stack> stack
    And I have pushed "<arg2>" onto the :<stack> stack
    And I have pushed "<arg3>" onto the :<stack> stack
    When I execute the Nudge instruction "<inst>"
    Then stack :<stack> should have depth <depth>
    And "3" should be in position -1 of the :int stack
    
    
    Examples:
    | arg1  | arg2  | arg3  | stack      | depth | inst             |
    | 1     | 2     | 4     | int        | 4     | int_depth        |
    | 1.0   | 2.0   | 3.0   | float      | 3     | float_depth      |
    | true  | false | true  | bool       | 3     | bool_depth       |
    | ref x | ref y | ref z | code       | 3     | code_depth       |
    | ref a | ref b | ref c | exec       | 3     | exec_depth       |
    | 0.1   | 0.2   | 0.3   | proportion | 3     | proportion_depth |
    | x     | y     | z     | name       | 3     | name_depth       |
    
