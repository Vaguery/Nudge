Feature: float_affine_interpolation
  In order to select any midpoint between two floats
  As a modeler
  I want an affine interpolation function
  
  Scenario Outline: 
    Given I have pushed "<arg1>" onto the :float stack
    And I have pushed "<arg2>" onto the :float stack
    And I have pushed "<lambda>" onto the :proportion stack
    When I execute the Nudge instruction "float_affine_interpolation"
    Then something close to "<result>" should be in position -1 of the :float stack
    And stack :float should have depth 1
  
  
    Examples: float_affine_interpolation
      | arg1  | arg2 | lambda | result |
      | 1.0   | 2.0  | 0.5    | 1.5    |
      | 1.0   | 2.0  | 0.2    | 1.2    |
      | 2.0   | 1.0  | 0.2    | 1.8    |
      | -12.0 | 12.0 | 0.5    | 0.0    |
      | -12.0 | 12.0 | 0.0    | -12.0  |
      | -12.0 | 12.0 | 1.0    | 12.0   |
      | 7.0   | 7.0  | 0.371  | 7.0    |
      
