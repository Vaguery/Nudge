Feature: Bool random
  In order to flip coins
  As a modeler
  I want a bool_random instruction

  Scenario: flip a coin
    When I execute the Nudge instruction "bool_random"
    Then the result should be a random :bool value
    Then stack :bool should have depth 1
  
  