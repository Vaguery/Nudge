Feature: int_affine_interpolation
  In order to select any midpoint between two ints
  As a modeler
  I want an affine interpolation function
  
  Scenario Outline: 
    Given I have pushed "<arg1>" onto the :int stack
    And I have pushed "<arg2>" onto the :int stack
    And I have pushed "<lambda>" onto the :proportion stack
    When I execute the Nudge instruction "int_affine_interpolation"
    Then "<result>" should be in position 0 of the :int stack
    And the top :error should include "<error>"
    
  
  
    Examples: exact results
      | arg1 | arg2 | lambda | result | error |
      | 1    | 3    | 0.5    | 2      |       |
      | 10   | 10   | 0.2    | 10     |       |
      | 3    | -1   | 0.2    | 2      |       |
      
    Examples: rounding
      | arg1 | arg2 | lambda | result | error |
      | 1    | 2    | 0.1    | 1      |       |
      | 1    | 2    | 0.6    | 2      |       |
      | 2    | 1    | 0.6    | 1      |       |
      | -2   | 2    | 0.7    | 1      |       |
      
    Examples: edge cases
      | arg1 | arg2 | lambda | result | error |
      | 2    | 2    | 0.1    | 2      |       |
      
      Examples: infinite results should create an :error
        | arg1                           | arg2                             | lambda                                                                                                                                                                                                                                                                                                                                                | result | error |
        | -99999999999999999999999999999 | 9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999 | .9 |        | NaN   |
