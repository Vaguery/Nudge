Feature: Bool random
  In order to flip coins
  As a modeler
  I want a bool_random instruction

  Scenario: flip a coin
    Given I have stubbed the random value method so it produces a :bool with value "blue"
    When I execute the Nudge instruction "bool_random"
    Then "blue" should be in position -1 of the :bool stack  
  
  