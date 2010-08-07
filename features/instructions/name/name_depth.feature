Feature: name depth
  In order to give scripts a bit of introspective capacity
  As a modeler
  I want Nudge to include instructions for counting things on stacks

  Scenario: works as expected
    Given I have pushed "a" onto the :name stack
    And I have pushed "b" onto the :name stack
    When I execute the Nudge instruction "name_depth"
    Then "2" should be in position -1 of the :int stack
  
  Scenario: returns 0 for an empty stack
    When I execute the Nudge instruction "name_depth"
    Then "0" should be in position -1 of the :int stack