Feature: float_sine instruction
  In order to describe and manipulate transcendental relations
  As a modeler
  I want a suite of :float Nudge trigonometry instructions
  
  Scenario Outline:
    Given I have pushed "<arg1>" onto the :float stack
    When I execute the Nudge instruction "<instruction>"
    Then something close to "<result>" should be in position -1 of the :float stack
    And stack :float should have depth 1
    
    Examples: float_sine
      | arg1             | instruction | result             |
      | 0.0              | float_sine  | 0.0                |
      | -0.0             | float_sine  | -0.0               |
      | 3.0              | float_sine  | 0.141120008059867  |
      | -2.0             | float_sine  | -0.909297426825682 |
      | 1.5707963267949  | float_sine  | 1.0                |
      | -2.0             | float_sine  | -0.909297426825682 |
      | 4.71238898038469 | float_sine  | -1.0               |
