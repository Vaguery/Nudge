Feature: Float pop
  In order to rearrange values I am generating and comparing
  As a modeler
  I want a suite of Nudge instructions to discard top items from stacks

  Scenario: top item on the stack is gone
    Given I have pushed "1.1" onto the :float stack
    And I have pushed "22.22" onto the :float stack
    And I have pushed "333.333" onto the :float stack
    When I execute the Nudge instruction "float_pop"
    Then the :float stack should be ["1.1", "22.22"]
