Feature: Int swap
  In order to shuffle values I am generating and comparing
  As a modeler
  I want a suite of Nudge instructions to swap top items on stacks

  Scenario: top two items on the stack switch positions
    Given I have pushed "1" onto the :int stack
    And I have pushed "22" onto the :int stack
    And I have pushed "333" onto the :int stack
    When I execute the Nudge instruction "int_swap"
    Then the :int stack should be ["1", "333", "22"]
