Feature: Proportion duplicate
  In order to make extra copies of stuff I'm manipulating
  As a modeler
  I want Nudge to have a suite of instructions for making copies of the top items on stacks

  Scenario: it makes a copy of the top thing
    Given I have pushed "0.11" onto the :proportion stack
    And I have pushed "0.22" onto the :proportion stack
    When I execute the Nudge instruction "proportion_duplicate"
    Then the :proportion stack should be ["0.11", "0.22", "0.22"]
  
