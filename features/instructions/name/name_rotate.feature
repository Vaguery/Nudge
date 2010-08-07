Feature: Name rotate
  In order to shuffle values I am generating and comparing
  As a modeler
  I want a suite of Nudge instructions to rotate topmost items on stacks

  Scenario: top three items on the stack exchange positions, pulling the 3rd item to the top
    Given I have pushed "a" onto the :name stack
    And I have pushed "b" onto the :name stack
    And I have pushed "c" onto the :name stack
    And I have pushed "d" onto the :name stack
    When I execute the Nudge instruction "name_rotate"
    Then the :name stack should be ["a", "c", "d", "b"]
