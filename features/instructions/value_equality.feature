Feature: Value equality
  In order to compare values on any stack
  As a modeler
  I want Nudge to include a suite of [stack]_equal_q instructions
  
  
  Scenario Outline: x_equal_q
    Given two values "<arg1>" and "<arg2>" on stack "<stack>"
    When I execute instruction "<instruction>"
    Then only "<result>" should be left on stack :bool
    And the other arguments should be gone
    
    Examples: float_equal_q
    | arg1 | arg2 | stack | instruction   | result |
    | 3.3  |  3.3 | float | float_equal_q |  true  |
    | 3.3  | 7.77 | float | float_equal_q | false  |
    | 0.0  | -0.0 | float | float_equal_q |  true  |
    
    
    Examples: bool_equal_q
    | arg1 | arg2  | stack | instruction   | result |
    | true |  true |  bool |  bool_equal_q |  true  |
    | true | false |  bool |  bool_equal_q | false  |
    
    
    Examples: int_equal_q
    | arg1 | arg2  | stack | instruction   | result |
    | 12   |  12   |  int  |   int_equal_q |  true  |
    | -12  |  12   |  int  |   int_equal_q | false  |
    
    
    Examples: proportion_equal_q
    | arg1 | arg2  | stack        | instruction        | result |
    | 0.12 | 0.12  |  proportion  | proportion_equal_q |  true  |
    | 0.10 | 0.101 |  proportion  | proportion_equal_q | false  |
    
    
    Examples: name_equal_q
    | arg1 | arg2  | stack  | instruction  | result |
    | x1   | x1    |  name  | name_equal_q |  true  |
    | x11  | x1    |  name  | name_equal_q | false  |
    
    
    Examples: code_equal_q (compares parsed code, not strings)
    | arg1                   | arg2                             | stack | instruction   | result |
    | "ref x"                | "ref x"                          |  code |  code_equal_q |  true  |
    | "ref \t\n  x"          | "ref x"                          |  code |  code_equal_q |  true  |
    | "do    foo"            | "do foo"                         |  code |  code_equal_q |  true  |
    | "value «int»\n«int» 8" | "\t value\t«int»\n\n\n«int»   8" |  code |  code_equal_q |  true  |
    | "block {do bar}"       | "block\t{\n  do  bar\n}"         |  code |  code_equal_q |  true  |    
    | "block {}"             | "block {block {}}"               |  code |  code_equal_q | false  |
    
    
    Examples: code_equal_q is always false for unparseable code
    | arg1       | arg2              | stack | instruction   | result |
    | "not code" | "neither is this" |  code |  code_equal_q | false  |
    | "block {}" | "busted"          |  code |  code_equal_q | false  |
    
    
    Examples: exec_equal_q (compares these trees, not strings)
    | arg1                   | arg2                     | stack | instruction   | result |
    | "ref x"                | "ref x"                  |  exec |  exec_equal_q |  true  |
    | "do foo"               | "do foo"                 |  exec |  exec_equal_q |  true  |
    | "value «int»\n«int» 8" | "value «int»\n«int» 8"   |  exec |  exec_equal_q |  true  |
    | "block {do bar}"       | "block\t{\n  do  bar\n}" |  exec |  exec_equal_q |  true  |    
    | "ref x"                | "ref y"                  |  exec |  exec_equal_q | false  |
    | "do foo"               | "do bar"                 |  exec |  exec_equal_q | false  |
    | "value «int»\n«int» 9" | "value «int»\n«int» 8"   |  exec |  exec_equal_q | false  |
    | "block {do bar}"       | "block\t{\n  do  foo}"   |  exec |  exec_equal_q | false  |    
