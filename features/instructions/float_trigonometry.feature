Feature: Float trignometry instructions
  In order to describe and manipulate transcendental relations
  As a modeler
  I want a suite of :float Nudge trigonometry instructions
  
  Scenario: sine, cosine and tangent
    Given I have placed "<arg1>" on the :float stack
    When I execute the Nudge code "<instruction>"
    Then a value very close to "<result>" should be on top of the :float stack
    And the argument should not remain on :float
    
    Scenario Outline: float_sine
      | arg1              | instruction   | result | 
      |  0.0              | do float_sine |  0.0               |
      | -0.0              | do float_sine | -0.0               |
      |  3.0              | do float_sine |  0.141120008059867 |
      | -2.0              | do float_sine | -0.909297426825682 |
      |  1.5707963267949  | do float_sine |  1.0               |
      | -2.0              | do float_sine | -0.909297426825682 |
      |  4.71238898038469 | do float_sine | -1.0               |
      
      
    Scenario Outline: float_cosine
      | arg1             | instruction     | result | 
      |  0.0             | do float_cosine | 1.0                |
      | -0.0             | do float_cosine | 1.0                |
      |  3.0             | do float_cosine | -0.989992496600445 |
      | -3.0             | do float_cosine | -0.989992496600445 |
      | 3.14159265358979 | do float_cosine | 1.0                |
      | 1.5707963267949  | do float_cosine | 0.0                |
      
      
    Scenario Outline: float_tangent
      | arg1             | instruction      | result | 
      |  0.0             | do float_tangent |      0.0           |
      | -0.0             | do float_tangent |     -0.0           |
      |  1.5707463267949 | do float_tangent |  19999.9999846877  |
      | -1.5707463267949 | do float_tangent | -19999.9999846877  |
      |  1.571           | do float_tangent |  -4909.82594232296 |
      
      