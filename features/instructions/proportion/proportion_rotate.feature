Feature: Proportion rotate
  In order to shuffle values I am generating and comparing
  As a modeler
  I want a suite of Nudge instructions to rotate topmost items on stacks

  Scenario: top three items on the stack exchange positions, pulling the 3rd item to the top
    Given I have pushed "0.1" onto the :proportion stack
    And I have pushed "0.2" onto the :proportion stack
    And I have pushed "0.3" onto the :proportion stack
    And I have pushed "0.4" onto the :proportion stack
    When I execute the Nudge instruction "proportion_rotate"
    Then the :proportion stack should be ["0.1", "0.3", "0.4", "0.2"]
