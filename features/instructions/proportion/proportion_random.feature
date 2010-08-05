Feature: Proportion random
  In order to create arbitrary proportions
  As a modeler
  I want an proportion_random instruction

  Scenario: roll a die
    Given I have stubbed the random value method so it produces a :proportion with value "foo"
    When I execute the Nudge instruction "proportion_random"
    Then "foo" should be in position -1 of the :proportion stack  
