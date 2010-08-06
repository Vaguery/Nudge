Feature: *_yankdup instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to pull things up from down inside any given stack
  
  Scenario Outline: *_yankdup instructions
    Given I have pushed "<filler>" onto the :<stack> stack
    And I have pushed "<filler>" onto the :<stack> stack
    And I have pushed "<filler>" onto the :<stack> stack
    And I have pushed "<filler>" onto the :<stack> stack
    And I have pushed "<mover>" onto the :<stack> stack

    And I have pushed "<source>" onto the :int stack
    When I execute the Nudge instruction "<inst>"
    Then stack :<stack> should have depth 5
    And "<new_top>" should be in position -1 of the :<stack> stack
    And "<arg1>" should be in position -5 of the :<stack> stack
    And "<arg2>" should be in position -4 of the :<stack> stack
    And "<arg1>" should be in position -3 of the :<stack> stack
    And "<arg3>" should be in position -2 of the :<stack> stack
    
    
    Examples: normal behavior
    | filler | mover | arg3  | stack      | source | inst               | new_top |
    | 1      | 2     | 3     | int        | 2      | int_yankdup        | 2       |
    | 1.0    | 2.0   | 3.0   | float      | 2      | float_yankdup      | 2.0     |
    | true   | false | true  | bool       | 2      | bool_yankdup       | false   |
    | ref x  | ref y | ref z | code       | 2      | code_yankdup       | ref y   |
    | ref a  | ref b | ref c | exec       | 2      | exec_yankdup       | ref b   |
    | 0.1    | 0.2   | 0.3   | proportion | 2      | proportion_yankdup | 0.2     |
    | x      | y     | z     | name       | 2      | name_yankdup       | y       |
    
    
    
    Examples: negative value for source
    | arg1  | arg2  | arg3  | stack      | source | inst               | new_top |
    | 1     | 2     | 3     | int        | -2     | int_yankdup        | 3       |
    | 1.0   | 2.0   | 3.0   | float      | -2     | float_yankdup      | 3.0     |
    | true  | false | true  | bool       | -2     | bool_yankdup       | true    |
    | ref x | ref y | ref z | code       | -2     | code_yankdup       | ref z   |
    | ref a | ref b | ref c | exec       | -2     | exec_yankdup       | ref c   |
    | 0.1   | 0.2   | 0.3   | proportion | -2     | proportion_yankdup | 0.3     |
    | x     | y     | z     | name       | -2     | name_yankdup       | z       |
    
    
    
    Examples: zero value for source
    | arg1  | arg2  | arg3  | stack      | source | inst               | new_top |
    | 1     | 2     | 3     | int        | 0      | int_yankdup        | 3       |
    | 1.0   | 2.0   | 3.0   | float      | 0      | float_yankdup      | 3.0     |
    | true  | false | true  | bool       | 0      | bool_yankdup       | true    |
    | ref x | ref y | ref z | code       | 0      | code_yankdup       | ref z   |
    | ref a | ref b | ref c | exec       | 0      | exec_yankdup       | ref c   |
    | 0.1   | 0.2   | 0.3   | proportion | 0      | proportion_yankdup | 0.3     |
    | x     | y     | z     | name       | 0      | name_yankdup       | z       |
    
    
    
    Examples: huge value for source
    | arg1  | arg2  | arg3  | stack      | source | inst               | new_top |
    | 1     | 2     | 3     | int        | 7162   | int_yankdup        | 1       |
    | 1.0   | 2.0   | 3.0   | float      | 7162   | float_yankdup      | 1.0     |
    | true  | false | true  | bool       | 7162   | bool_yankdup       | true    |
    | ref x | ref y | ref z | code       | 7162   | code_yankdup       | ref x   |
    | ref a | ref b | ref c | exec       | 7162   | exec_yankdup       | ref a   |
    | 0.1   | 0.2   | 0.3   | proportion | 7162   | proportion_yankdup | 0.1     |
    | x     | y     | z     | name       | 7162   | name_yankdup       | x       |
