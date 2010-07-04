Feature: Value equality
  In order to compare values on any stack
  As a modeler
  I want Nudge to include a suite of [stack]_equal_q instructions
  
  
  Scenario Outline: x_equal_q
    Given I have pushed "<arg1>" onto the :<stack> stack
    And I have pushed "<arg2>" onto the :<stack> stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be on top of the bool stack
    And stack :<stack> should have depth <depth>
    
    
    
    Examples: float_equal_q
    | arg1 | stack | arg2 | stack | instruction  | result | stack | depth |
    | 3.3  | float | 3.3  | float | float_equal? | true   | float | 0     |
    | 3.3  | float | 7.77 | float | float_equal? | false  | float | 0     |
    | 0.0  | float | -0.0 | float | float_equal? | true   | float | 0     |
    
    
    Examples: bool_equal_q
    | arg1 | stack | arg2  | stack | instruction | result | stack | depth |
    | true | bool  | true  | bool  | bool_equal? | true   | bool  | 1     |
    | true | bool  | false | bool  | bool_equal? | false  | bool  | 1     |
    
    
    Examples: int_equal_q
    | arg1 | stack | arg2 | stack | instruction | result | stack | depth |
    | 12   | int   | 12   | int   | int_equal?  | true   | int   | 0     |
    | -12  | int   | 12   | int   | int_equal?  | false  | int   | 0     |
    
    
    Examples: proportion_equal_q
    | arg1 | stack      | arg2  | stack      | instruction       | result | stack      | depth |
    | 0.12 | proportion | 0.12  | proportion | proportion_equal? | true   | proportion | 0     |
    | 0.10 | proportion | 0.101 | proportion | proportion_equal? | false  | proportion | 0     |
    
    
    Examples: name_equal_q
    | arg1 | stack | arg2 | stack | instruction | result | stack | depth |
    | x1   | name  | x1   | name  | name_equal? | true   | name  | 0     |
    | x11  | name  | x1   | name  | name_equal? | false  | name  | 0     |
    
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
    
    Examples: code_equal? (compares parsed code, not strings)
    | arg1                | stack | arg2                   | stack | instruction | result | stack | depth |
    | ref x               | code  | ref x                  | code  | code_equal? | true   | code  | 0     |
    | ref \t\n  x         | code  | ref x                  | code  | code_equal? | true   | code  | 0     |
    | do    foo           | code  | do foo                 | code  | code_equal? | true   | code  | 0     |
    | value «int»\n«int»8 | code  | value\t«int»\n«int» 8  | code  | code_equal? | true   | code  | 0     |
    | block {do bar}      | code  | block\t{\n  do  bar\n} | code  | code_equal? | true   | code  | 0     |
    | block {}            | code  | block {block {}}       | code  | code_equal? | false  | code  | 0     |
    
    
    Examples: code_equal_q is always false for unparseable code
    | arg1     | stack | arg2            | stack | instruction | result | stack | depth |
    | not code | code  | neither is this | code  | code_equal? | false  | code  | 0     |
    | block {} | code  | busted          | code  | code_equal? | false  | code  | 0     |
