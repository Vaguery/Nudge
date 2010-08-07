Feature: Bool swap
  In order to shuffle values I am generating and comparing
  As a modeler
  I want a suite of Nudge instructions to swap top items on stacks

  Scenario: top two items on the stack switch positions
    Given I have pushed "false" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    When I execute the Nudge instruction "bool_swap"
    Then the :bool stack should be ["true", "false"]
    