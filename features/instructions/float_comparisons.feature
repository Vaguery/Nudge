Feature: Float comparison instructions
  In order to compare machine-precision numerical values
  As a modeler
  I want a suite of :float Nudge instructions that compare their size
  
  Scenario: greater_than_q and less_than_q 
    Given I have placed "<arg1>" on the :float stack
    Given I have placed "<arg2>" on the :float stack immediately above it
    When I execute the Nudge code "<instruction>"
    Then a value very close to "<result>" should be on top of the :bool stack
    And the arguments should not remain on :float
    
    Scenario Outline: float_greater_than_q
    | arg1         | arg2 | instruction             | result |
    |  3.0         |  4.1 | do float_greater_than_q |  false |
    |  4.1         |  3.0 | do float_greater_than_q |   true |
    |  3.0         |  3.0 | do float_greater_than_q |  false |
    |  3.300000001 |  3.3 | do float_greater_than_q |   true |
    | -2.5         | 16.0 | do float_greater_than_q |  false |
    | -2.5         | -4.0 | do float_greater_than_q |   true |
    
    
    Scenario Outline: float_less_than_q
    | arg1         | arg2 | instruction          | result |
    |  3.0         |  4.1 | do float_less_than_q |   true |
    |  4.1         |  3.0 | do float_less_than_q |  false |
    |  3.0         |  3.0 | do float_less_than_q |  false |
    |  3.300000001 |  3.3 | do float_less_than_q |  false |
    | -2.5         | 16.0 | do float_less_than_q |   true |
    | -2.5         | -4.0 | do float_less_than_q |  false |
