Feature: Proportion pop
  In order to rearrange values I am generating and comparing
  As a modeler
  I want a suite of Nudge instructions to discard top items from stacks

  Scenario: top item on the stack is gone
    Given I have pushed "0.1" onto the :proportion stack
    And I have pushed "0.2" onto the :proportion stack
    And I have pushed "0.3" onto the :proportion stack
    When I execute the Nudge instruction "proportion_pop"
    Then the :proportion stack should be ["0.1", "0.2"]
