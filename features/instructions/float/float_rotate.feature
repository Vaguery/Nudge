Feature: Float rotate
  In order to shuffle values I am generating and comparing
  As a modeler
  I want a suite of Nudge instructions to rotate topmost items on stacks

  Scenario: top three items on the stack exchange positions, pulling the 3rd item to the top
    Given I have pushed "1.0" onto the :float stack
    And I have pushed "2.0" onto the :float stack
    And I have pushed "3.0" onto the :float stack
    And I have pushed "4.0" onto the :float stack
    When I execute the Nudge instruction "float_rotate"
    Then the :float stack should be ["1.0", "3.0", "4.0", "2.0"]
