Feature: Bool depth
  In order to give scripts a bit of introspective capacity
  As a modeler
  I want Nudge to include instructions for counting things on stacks

  Scenario: works as expected
    Given I have pushed "false" onto the :bool stack
    And I have pushed "false" onto the :bool stack
    When I execute the Nudge instruction "bool_depth"
    Then "2" should be in position -1 of the :int stack
  
  Scenario: returns 0 for an empty stack
    When I execute the Nudge instruction "bool_depth"
    Then "0" should be in position -1 of the :int stack