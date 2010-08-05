Feature: *_yank instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to pull things up from down inside any given stack
  
  Scenario Outline: *_yank instructions
    Given I have pushed "<arg1>" onto the :<stack> stack
    And I have pushed "<arg2>" onto the :<stack> stack
    And I have pushed "<arg1>" onto the :<stack> stack
    And I have pushed "<arg3>" onto the :<stack> stack
    And I have pushed "<source>" onto the :int stack
    When I execute the Nudge instruction "<inst>"
    Then stack :<stack> should have depth 4
    And "<new_top>" should be in position -1 of the :<stack> stack
    And "<replacement>" should be in position <old_spot> of the :<stack> stack
    
    Examples: normal behavior
    | arg1  | arg2  | arg3  | stack      | source | inst            | new_top | replacement | old_spot |
    | 1     | 2     | 3     | int        | 2      | int_yank        | 2       | 1           | -3       |
    | 1.0   | 2.0   | 3.0   | float      | 2      | float_yank      | 2.0     | 1.0         | -3       |
    | true  | false | true  | bool       | 2      | bool_yank       | false   | true        | -3       |
    | ref x | ref y | ref z | code       | 2      | code_yank       | ref y   | ref x       | -3       |
    | ref a | ref b | ref c | exec       | 2      | exec_yank       | ref b   | ref a       | -3       |
    | 0.1   | 0.2   | 0.3   | proportion | 2      | proportion_yank | 0.2     | 0.1         | -3       |
    | x     | y     | z     | name       | 2      | name_yank       | y       | x           | -3       |
    
    
    
    Examples: negative value for source
    | arg1  | arg2  | arg3  | stack      | source | inst            | new_top | replacement | old_spot |
    | 1     | 2     | 3     | int        | -2     | int_yank        | 3       | 2           | -3       |
    | 1.0   | 2.0   | 3.0   | float      | -2     | float_yank      | 3.0     | 2.0         | -3       |
    | true  | false | true  | bool       | -2     | bool_yank       | true    | false       | -3       |
    | ref x | ref y | ref z | code       | -2     | code_yank       | ref z   | ref y       | -3       |
    | ref a | ref b | ref c | exec       | -2     | exec_yank       | ref c   | ref b       | -3       |
    | 0.1   | 0.2   | 0.3   | proportion | -2     | proportion_yank | 0.3     | 0.2         | -3       |
    | x     | y     | z     | name       | -2     | name_yank       | z       | y           | -3       |
    
    
    
    Examples: zero value for source
    | arg1  | arg2  | arg3  | stack      | source | inst            | new_top | replacement | old_spot |
    | 1     | 2     | 3     | int        | 0      | int_yank        | 3       | 2           | -3       |
    | 1.0   | 2.0   | 3.0   | float      | 0      | float_yank      | 3.0     | 2.0         | -3       |
    | true  | false | true  | bool       | 0      | bool_yank       | true    | false       | -3       |
    | ref x | ref y | ref z | code       | 0      | code_yank       | ref z   | ref y       | -3       |
    | ref a | ref b | ref c | exec       | 0      | exec_yank       | ref c   | ref b       | -3       |
    | 0.1   | 0.2   | 0.3   | proportion | 0      | proportion_yank | 0.3     | 0.2         | -3       |
    | x     | y     | z     | name       | 0      | name_yank       | z       | y           | -3       |
    
    
    
    Examples: huge value for source
    | arg1  | arg2  | arg3  | stack      | source | inst            | new_top | replacement | old_spot |
    | 1     | 2     | 3     | int        | 7162   | int_yank        | 1       | 2           | 0        |
    | 1.0   | 2.0   | 3.0   | float      | 7162   | float_yank      | 1.0     | 2.0         | 0        |
    | true  | false | true  | bool       | 7162   | bool_yank       | true    | false       | 0        |
    | ref x | ref y | ref z | code       | 7162   | code_yank       | ref x   | ref y       | 0        |
    | ref a | ref b | ref c | exec       | 7162   | exec_yank       | ref a   | ref b       | 0        |
    | 0.1   | 0.2   | 0.3   | proportion | 7162   | proportion_yank | 0.1     | 0.2         | 0        |
    | x     | y     | z     | name       | 7162   | name_yank       | x       | y           | 0        |
