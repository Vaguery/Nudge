Feature: Int random
  In order to sample discrete random variables
  As a modeler
  I want an int_random instruction

  Scenario: roll a die
    Given I have stubbed the random value method so it produces an :int with value "halloo"
    When I execute the Nudge instruction "int_random"
    Then "halloo" should be in position -1 of the :int stack  
