Feature: Proportion arity-2 math instructions
  In order to describe and manipulate proportional quantities and probabilities
  As a modeler
  I want a suite of :proportion Nudge arithmetic instructions
  
  Scenario Outline: basic arity-2 instructions
    Given I have placed "<arg1>" on the :proportion stack
    And I have placed "<arg2>" on top of that
    When I execute the Nudge code "<instruction>"
    Then the value "<result>" should be on top of the :proportion stack
    And a message "<error_msg>" should be on the :error stack
    And the arguments should not remain on :proportion
    
    Examples: proportion_bounded_add
      | arg1   | arg2   | instruction                | result | error_msg |
      |  0.6   |  0.2   | do proportion_bounded_add  |   0.8  | |
      |  0.9   |  0.2   | do proportion_bounded_add  |   1.0  | |
      |  0.0   |  0.4   | do proportion_bounded_add  |   0.4  | |
      
      
    Examples: proportion_bounded_divide
      | arg1   | arg2   | instruction                   | result | error_msg |
      |  0.6   |  0.2   | do proportion_bounded_divide  |   1.0  | |
      |  0.2   |  0.4   | do proportion_bounded_divide  |   0.5  | |
      |  0.0   |  0.4   | do proportion_bounded_divide  |   0.0  | |
      |  0.3   |  0.0   | do proportion_bounded_divide  |        | proportion_bounded_divide: divide by 0.0 |
      |  0.0   |  0.0   | do proportion_bounded_divide  |        | proportion_bounded_divide: divide by 0.0 |
      
      
    Examples: proportion_bounded_subtract
      | arg1   | arg2   | instruction                     | result | error_msg |
      |  0.6   |  0.2   | do proportion_bounded_subtract  |   0.4  | |
      |  0.2   |  0.6   | do proportion_bounded_subtract  |   0.0  | |
      |  0.3   |  0.0   | do proportion_bounded_subtract  |   0.3  | |
      
      
    Examples: proportion_max
      | arg1  | arg2 | instruction        | result | error_msg |
      |  0.1  |  0.2 | do proportion_max  |  0.2   | |
      |  0.3  |  0.1 | do proportion_max  |  0.3   | |
      |  0.1  |  0.1 | do proportion_max  |  0.1   | |
      
      
    Examples: proportion_min
      | arg1  | arg2 | instruction        | result | error_msg |
      |  0.1  |  0.2 | do proportion_min  |  0.1   | |
      |  0.3  |  0.1 | do proportion_min  |  0.1   | |
      |  0.1  |  0.1 | do proportion_min  |  0.1   | |
      
      
    Examples: proportion_multiply
      | arg1  | arg2 | instruction             | result | error_msg |
      |  0.1  |  0.2 | do proportion_multiply  |  0.02  | |
      |  0.3  |  0.9 | do proportion_multiply  |  0.27  | |
      |  0.0  |  0.1 | do proportion_multiply  |  0.0   | |
      |  1.0  |  0.3 | do proportion_multiply  |  0.3   | |
      
      
