Feature: Code rotate
  In order to shuffle values I am generating and comparing
  As a modeler
  I want a suite of Nudge instructions to rotate topmost items on stacks

  Scenario: top three items on the stack exchange positions, pulling the 3rd item to the top
    Given I have pushed "ref a" onto the :code stack
    And I have pushed "ref b" onto the :code stack
    And I have pushed "ref c" onto the :code stack
    And I have pushed "ref d" onto the :code stack
    When I execute the Nudge instruction "code_rotate"
    Then the :code stack should be ["ref a", "ref c", "ref d", "ref b"]
