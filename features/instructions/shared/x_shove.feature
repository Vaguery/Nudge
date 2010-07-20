Feature: *_shove instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to push things down into any given stack
  
  Scenario Outline: *_shove instructions
    Given I have pushed "<arg1>" onto the :<stack> stack
    And I have pushed "<arg1>" onto the :<stack> stack
    And I have pushed "<arg1>" onto the :<stack> stack
    And I have pushed "<arg2>" onto the :<stack> stack
    And I have pushed "<dest>" onto the :int stack
    When I execute the Nudge instruction "<inst>"
    Then stack :<stack> should have depth 4
    And "<arg2>" should be in position <target> of the :<stack> stack
    
    Examples: normal behavior
    | arg1  | arg2  | stack      | dest | target | inst             |
    | 1     | 2     | int        | 2    | -3     | int_shove        |
    | 1.0   | 2.0   | float      | 2    | -3     | float_shove      |
    | true  | false | bool       | 2    | -3     | bool_shove       |
    | ref x | ref y | code       | 2    | -3     | code_shove       |
    | ref a | ref b | exec       | 2    | -3     | exec_shove       |
    | 0.1   | 0.2   | proportion | 2    | -3     | proportion_shove |
    | x     | y     | name       | 2    | -3     | name_shove       |
    
    
    Examples: negative value of destination
    | arg1  | arg2  | stack      | dest | target | inst             |
    | 1     | 2     | int        | -2   | -1     | int_shove        |
    | 1.0   | 2.0   | float      | -2   | -1     | float_shove      |
    | true  | false | bool       | -2   | -1     | bool_shove       |
    | ref x | ref y | code       | -2   | -1     | code_shove       |
    | ref a | ref b | exec       | -2   | -1     | exec_shove       |
    | 0.1   | 0.2   | proportion | -2   | -1     | proportion_shove |
    | x     | y     | name       | -2   | -1     | name_shove       |
    
    
    Examples: zero value of destination
    | arg1  | arg2  | stack      | dest | target | inst             |
    | 1     | 2     | int        | 0    | -1     | int_shove        |
    | 1.0   | 2.0   | float      | 0    | -1     | float_shove      |
    | true  | false | bool       | 0    | -1     | bool_shove       |
    | ref x | ref y | code       | 0    | -1     | code_shove       |
    | ref a | ref b | exec       | 0    | -1     | exec_shove       |
    | 0.1   | 0.2   | proportion | 0    | -1     | proportion_shove |
    | x     | y     | name       | 0    | -1     | name_shove       |
    
    
    Examples: huge value of destination
    | arg1  | arg2  | stack      | dest | target | inst             |
    | 1     | 2     | int        | 9182 | 0      | int_shove        |
    | 1.0   | 2.0   | float      | 9182 | 0      | float_shove      |
    | true  | false | bool       | 9182 | 0      | bool_shove       |
    | ref x | ref y | code       | 9182 | 0      | code_shove       |
    | ref a | ref b | exec       | 9182 | 0      | exec_shove       |
    | 0.1   | 0.2   | proportion | 9182 | 0      | proportion_shove |
    | x     | y     | name       | 9182 | 0      | name_shove       |
