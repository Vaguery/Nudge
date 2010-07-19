Feature: float_multiply
  In order to describe and manipulate machine-precision numerical variables
  As a modeler
  I want a suite of :float Nudge arithmetic instructions
  
  Scenario Outline: 
    Given I have pushed "<arg1>" onto the :float stack
    And I have pushed "<arg2>" onto the :float stack
    When I execute the Nudge instruction "<instruction>"
    Then something close to "<result>" should be in position -1 of the :float stack
    And stack :float should have depth 1

    Examples: float_multiply
      | arg1 | arg2 | instruction    | result |
      | 3.0  | 4.1  | float_multiply | 12.3   |
      | 0.0  | 3.3  | float_multiply | 0.0    |
      | -2.5 | 16.0 | float_multiply | -40.0  |
      | -2.5 | -4.0 | float_multiply | 10.0   |
                                               