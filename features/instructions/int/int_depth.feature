Feature: int depth
  In order to give scripts a bit of introspective capacity
  As a modeler
  I want Nudge to include instructions for counting things on stacks

  Scenario: works as expected
    Given I have pushed "11" onto the :int stack
    And I have pushed "22" onto the :int stack
    When I execute the Nudge instruction "int_depth"
    Then "2" should be in position -1 of the :int stack
  
  Scenario: returns 0 for an empty stack
    When I execute the Nudge instruction "int_depth"
    Then "0" should be in position -1 of the :int stack