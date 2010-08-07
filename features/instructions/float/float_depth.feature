Feature: float depth
  In order to give scripts a bit of introspective capacity
  As a modeler
  I want Nudge to include instructions for counting things on stacks

  Scenario: works as expected
    Given I have pushed "1.1" onto the :float stack
    And I have pushed "2.2" onto the :float stack
    When I execute the Nudge instruction "float_depth"
    Then "2" should be in position -1 of the :int stack
  
  Scenario: returns 0 for an empty stack
    When I execute the Nudge instruction "float_depth"
    Then "0" should be in position -1 of the :int stack