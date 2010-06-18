Feature: Conditional instructions
  In order to search for branching algorithms
  As a modeler
  I want the Nudge language to include a set of conditional instructions "x_if"
  
  Scenario: x_if
    Given two values "<arg1>" and "<arg2>" on stack :x
    And a :bool value with value "<t_or_f>"
    When I execute instruction "<instruction>"
    Then only "<result>" should be left on stack :x
    And the other arguments should be gone
    
    Scenario Outline: float_if
    | arg1 | arg2 | t_or_f | instruction | result |
    | 3.3  | 7.77 | true   | do float_if | 3.3    |
    | 3.3  | 7.77 | false  | do float_if | 7.77   |
    
    
    Scenario Outline: int_if
    | arg1 | arg2 | t_or_f | instruction | result |
    | 1    | 222  | true   | do int_if   | 1      |
    | 1    | 222  | false  | do int_if   | 222    |
    
    
    Scenario Outline: code_if
    | arg1  | arg2 | t_or_f | instruction | result |
    | ref a | do x | true   | do code_if  | ref a  |
    | ref a | do x | false  | do code_if  | do x   |
    
    
    Scenario Outline: exec_if
    | arg1  | arg2 | t_or_f | instruction | result |
    | ref a | do x | true   | do exec_if  | ref a  |
    | ref a | do x | true   | do exec_if  | do x   |
    
    
    Scenario Outline: proportion_if
    | arg1  | arg2 | t_or_f | instruction      | result |
    | 0.222 | 0.88 | true   | do proportion_if | 0.222  |
    | 0.222 | 0.88 | false  | do proportion_if | 0.88   |
    
    
    Scenario Outline: name_if
    | arg1 | arg2 | t_or_f | instruction | result |
    | x1   | foo  | true   | do name_if  | x1     |
    | x1   | foo  | false  | do name_if  | foo    |
    