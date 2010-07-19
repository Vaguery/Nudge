Feature: float_cosine instruction
  In order to describe and manipulate transcendental relations
  As a modeler
  I want a suite of :float Nudge trigonometry instructions
  
  Scenario Outline: cosine 
    Given I have pushed "<arg1>" onto the :float stack
    When I execute the Nudge instruction "<instruction>"
    Then something close to "<result>" should be in position -1 of the :float stack
    And stack :float should have depth 1
    
    
    Examples: float_cosine
      | arg1            | instruction  | result             |
      | 0.0             | float_cosine | 1.0                |
      | -0.0            | float_cosine | 1.0                |
      | 3.0             | float_cosine | -0.989992496600445 |
      | -3.0            | float_cosine | -0.989992496600445 |
      | 3.14159         | float_cosine | -1.0               |
      | 1.5707963267949 | float_cosine | 0.0                |
      
