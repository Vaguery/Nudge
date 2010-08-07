Feature: Int pop
  In order to rearrange values I am generating and comparing
  As a modeler
  I want a suite of Nudge instructions to discard top items from stacks

  Scenario: top item on the stack is gone
    Given I have pushed "11111" onto the :int stack
    And I have pushed "222" onto the :int stack
    And I have pushed "3" onto the :int stack
    When I execute the Nudge instruction "int_pop"
    Then the :int stack should be ["11111", "222"]
