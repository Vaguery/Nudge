Feature: Int random
  In order to sample discrete random variables
  As a modeler
  I want an int_random instruction

  Scenario: roll a die
    When I execute the Nudge instruction "int_random"
    Then the result should be a random :int value
    Then stack :int should have depth 1
  
