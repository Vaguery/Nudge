Feature: Float random
  In order to sample continuous-valued random variables
  As a modeler
  I want a float_random instruction

  Scenario: sample a continuum
    Given I have stubbed the random value method so it produces a :float with value "9.9.9.9"
    When I execute the Nudge instruction "float_random"
    Then "9.9.9.9" should be in position -1 of the :float stack  
  
