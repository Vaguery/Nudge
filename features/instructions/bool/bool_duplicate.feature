Feature: Bool duplicate
  In order to make extra copies of stuff I'm manipulating
  As a modeler
  I want Nudge to have a suite of instructions for making copies of the top items on stacks

  Scenario: it makes a copy of the top thing
    Given I have pushed "false" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    When I execute the Nudge instruction "bool_duplicate"
    Then the :bool stack should be ["false", "true", "true"]
  
