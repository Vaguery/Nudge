Feature: Name swap
  In order to shuffle values I am generating and comparing
  As a modeler
  I want a suite of Nudge instructions to swap top items on stacks

  Scenario: top two items on the stack switch positions
    Given I have pushed "a" onto the :name stack
    And I have pushed "b" onto the :name stack
    And I have pushed "c" onto the :name stack
    When I execute the Nudge instruction "name_swap"
    Then the :name stack should be ["a", "c", "b"]
