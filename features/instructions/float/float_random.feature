Feature: Float random
  In order to sample continuous-valued random variables
  As a modeler
  I want a float_random instruction

  Scenario: sample a continuum
    When I execute the Nudge instruction "float_random"
    Then the result should be a random :float value
    Then stack :float should have depth 1
  
