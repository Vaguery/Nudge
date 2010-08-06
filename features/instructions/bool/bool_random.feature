Feature: Bool random
  In order to flip coins
  As a modeler
  I want a bool_random instruction

  Scenario: should return a :bool
    When I execute the Nudge instruction "bool_random"
    Then stack :bool should have depth 1 
  
  Scenario: should return a random value with equal probability
    Given context
    When event
    Then outcome
  
  
  
  
  