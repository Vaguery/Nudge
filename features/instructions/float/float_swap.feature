Feature: Float swap
  In order to shuffle values I am generating and comparing
  As a modeler
  I want a suite of Nudge instructions to swap top items on stacks

  Scenario: top two items on the stack switch positions
    Given I have pushed "0.1" onto the :float stack
    And I have pushed "2.2" onto the :float stack
    And I have pushed "33.3" onto the :float stack
    When I execute the Nudge instruction "float_swap"
    Then the :float stack should be ["0.1", "33.3", "2.2"]
