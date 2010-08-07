Feature: Name duplicate
  In order to make extra copies of stuff I'm manipulating
  As a modeler
  I want Nudge to have a suite of instructions for making copies of the top items on stacks

  Scenario: it makes a copy of the top thing
    Given I have pushed "a" onto the :name stack
    And I have pushed "z" onto the :name stack
    When I execute the Nudge instruction "name_duplicate"
    Then the :name stack should be ["a", "z", "z"]
  
