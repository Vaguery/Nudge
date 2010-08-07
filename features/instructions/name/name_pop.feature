Feature: Name pop
  In order to rearrange values I am generating and comparing
  As a modeler
  I want a suite of Nudge instructions to discard top items from stacks

  Scenario: top item on the stack is gone
    Given I have pushed "a" onto the :name stack
    And I have pushed "b" onto the :name stack
    And I have pushed "c" onto the :name stack
    When I execute the Nudge instruction "name_pop"
    Then the :name stack should be ["a", "b"]
