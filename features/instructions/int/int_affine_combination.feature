Feature: int_affine_combination
  In order to select any point on the line defined by two ints
  As a modeler
  I want an affine combination function
  
  Scenario Outline: 
    Given I have pushed "<arg1>" onto the :int stack
    And I have pushed "<arg2>" onto the :int stack
    And I have pushed "<lambda>" onto the :float stack
    When I execute the Nudge instruction "int_affine_combination"
    Then "<result>" should be in position 0 of the :int stack
    And the top :error should include "<error>"
  
  
    Examples: just like affine_interpolation
      | arg1 | arg2 | lambda | result | error |
      | 1    | 3    | 0.5    | 2      |       |
      | 10   | 10   | 0.2    | 10     |       |
      | 3    | -1   | 0.2    | 2      |       |
      | 1    | 2    | 0.1    | 1      |       |
      | 1    | 2    | 0.6    | 2      |       |
      | 2    | 1    | 0.6    | 1      |       |
      | -2   | 2    | 0.7    | 1      |       |
      | 2    | 2    | 0.1    | 2      |       |
      
      
    Examples: but also outside the range
      | arg1 | arg2 | lambda | result | error |
      | 1    | 2    | 2.6    | 4      |       |
      | 1    | 2    | 1.2    | 2      |       |
      | 2    | 1    | 2.6    | -1     |       |
      | -20  | 10   | 92.191 | 2746   |       |
      | 10   | -20  | 92.191 | -2756  |       |

    Examples: infinite results should create an :error
      | arg1                           | arg2                             | lambda                                                                                                                                                                                                                                                                                                                                                 | result | error |
      | -99999999999999999999999999999 | 99999999999999999999999999999999 | 9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999.9 |        | NaN   |
      
