Feature: Int rotate
  In order to shuffle values I am generating and comparing
  As a modeler
  I want a suite of Nudge instructions to rotate topmost items on stacks

  Scenario: top three items on the stack exchange positions, pulling the 3rd item to the top
    Given I have pushed "1" onto the :int stack
    And I have pushed "2" onto the :int stack
    And I have pushed "3" onto the :int stack
    And I have pushed "4" onto the :int stack
    When I execute the Nudge instruction "int_rotate"
    Then the :int stack should be ["1", "3", "4", "2"]
