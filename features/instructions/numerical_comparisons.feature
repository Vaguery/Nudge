Feature: Numerical comparison instructions
  In order to compare machine-precision numerical values
  As a modeler
  I want a suite of :float Nudge instructions that compare their size
  
  Scenario Outline: greater_than_q and less_than_q 
    Given I have placed "<arg1>" on the "<type>" stack
    And I have placed "<arg2>" on the same stack immediately above it
    When I execute the Nudge code "<instruction>"
    Then a value very close to "<result>" should be on top of the :bool stack
    And the arguments should not remain on their original stack
    
    Examples: float_greater_than_q
    | arg1         | type  | arg2 | instruction             | result |
    |  3.0         | float |  4.1 | do float_greater_than_q |  false |
    |  4.1         | float |  3.0 | do float_greater_than_q |   true |
    |  3.0         | float |  3.0 | do float_greater_than_q |  false |
    |  3.300000001 | float |  3.3 | do float_greater_than_q |   true |
    | -2.5         | float | 16.0 | do float_greater_than_q |  false |
    | -2.5         | float | -4.0 | do float_greater_than_q |   true |
    
    
    Examples: float_less_than_q
    | arg1         | type  | arg2 | instruction          | result |
    |  3.0         | float |  4.1 | do float_less_than_q |   true |
    |  4.1         | float |  3.0 | do float_less_than_q |  false |
    |  3.0         | float |  3.0 | do float_less_than_q |  false |
    |  3.300000001 | float |  3.3 | do float_less_than_q |  false |
    | -2.5         | float | 16.0 | do float_less_than_q |   true |
    | -2.5         | float | -4.0 | do float_less_than_q |  false |
    
    
    Examples: int_greater_than_q
    | arg1 | type | arg2 | instruction           | result |
    |  3   | int  |  4   | do int_greater_than_q |  false |
    |  4   | int  |  3   | do int_greater_than_q |   true |
    |  3   | int  |  3   | do int_greater_than_q |  false |
    | -2   | int  | 16   | do int_greater_than_q |  false |
    | -2   | int  | -4   | do int_greater_than_q |   true |
    
    
    Examples: int_less_than_q
    | arg1 | type | arg2 | instruction        | result |
    |  3   | int  |  4   | do int_less_than_q |   true |
    |  4   | int  |  3   | do int_less_than_q |  false |
    |  3   | int  |  3   | do int_less_than_q |  false |
    | -2   | int  | 16   | do int_less_than_q |   true |
    | -2   | int  | -4   | do int_less_than_q |  false |
    