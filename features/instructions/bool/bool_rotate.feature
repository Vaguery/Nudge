Feature: Bool rotate
  In order to shuffle values I am generating and comparing
  As a modeler
  I want a suite of Nudge instructions to rotate topmost items on stacks

  Scenario: top three items on the stack exchange positions, pulling the 3rd item to the top
    Given I have pushed "false" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "false" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    When I execute the Nudge instruction "bool_rotate"
    Then the :bool stack should be ["false", "false", "true", "true"]
