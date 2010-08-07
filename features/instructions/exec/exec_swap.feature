Feature: Exec swap
  In order to shuffle values I am generating and comparing
  As a modeler
  I want a suite of Nudge instructions to swap top items on stacks

  Scenario: top two items on the stack switch positions
    Given I have pushed "ref a" onto the :exec stack
    And I have pushed "ref b" onto the :exec stack
    And I have pushed "ref c" onto the :exec stack
    When I execute the Nudge instruction "exec_swap"
    Then the :exec stack should be ["ref a", "ref c", "ref b"]
