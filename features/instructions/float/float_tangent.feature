Feature: float_tangent instruction
  In order to describe and manipulate transcendental relations
  As a modeler
  I want a suite of :float Nudge trigonometry instructions
  
  Scenario Outline:  tangent
    Given I have pushed "<arg1>" onto the :float stack
    When I execute the Nudge instruction "<instruction>"
    Then something close to "<result>" should be in position -1 of the :float stack
    And stack :float should have depth 1
      
      
    Examples: float_tangent
      | arg1             | instruction   | result            |
      | 0.0              | float_tangent | 0.0               |
      | -0.0             | float_tangent | -0.0              |
      | 1.5707463267949  | float_tangent | 19999.9999846877  |
      | -1.5707463267949 | float_tangent | -19999.9999846877 |
      | 1.571            | float_tangent | -4909.82594232296 |
      
