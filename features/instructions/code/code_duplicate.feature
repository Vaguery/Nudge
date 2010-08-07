Feature: Code duplicate
  In order to make extra copies of stuff I'm manipulating
  As a modeler
  I want Nudge to have a suite of instructions for making copies of the top items on stacks

  Scenario: it makes a copy of the top thing
    Given I have pushed "ref a" onto the :code stack
    And I have pushed "ref b" onto the :code stack
    When I execute the Nudge instruction "code_duplicate"
    Then the :code stack should be ["ref a", "ref b", "ref b"]
  
