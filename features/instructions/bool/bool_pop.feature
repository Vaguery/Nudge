Feature: Bool pop
  In order to rearrange values I am generating and comparing
  As a modeler
  I want a suite of Nudge instructions to discard top items from stacks

  Scenario: top item on the stack is gone
    Given I have pushed "false" onto the :bool stack
    And I have pushed "false" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    When I execute the Nudge instruction "bool_pop"
    Then the :bool stack should be ["false", "false"]
