Feature: Proportion swap
  In order to shuffle values I am generating and comparing
  As a modeler
  I want a suite of Nudge instructions to swap top items on stacks

  Scenario: top two items on the stack switch positions
    Given I have pushed "0.1" onto the :proportion stack
    And I have pushed "0.2" onto the :proportion stack
    And I have pushed "0.3" onto the :proportion stack
    When I execute the Nudge instruction "proportion_swap"
    Then the :proportion stack should be ["0.1", "0.3", "0.2"]
