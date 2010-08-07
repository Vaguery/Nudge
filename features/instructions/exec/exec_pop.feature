Feature: Exec pop
  In order to rearrange values I am generating and comparing
  As a modeler
  I want a suite of Nudge instructions to discard top items from stacks

  Scenario: top item on the stack is gone
    Given I have pushed "ref a" onto the :exec stack
    And I have pushed "ref b" onto the :exec stack
    And I have pushed "ref gone" onto the :exec stack
    When I execute the Nudge instruction "exec_pop"
    Then the :exec stack should be ["ref a", "ref b"]
