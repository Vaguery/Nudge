Feature: Float duplicate
  In order to make extra copies of stuff I'm manipulating
  As a modeler
  I want Nudge to have a suite of instructions for making copies of the top items on stacks

  Scenario: it makes a copy of the top thing
    Given I have pushed "1.1" onto the :float stack
    And I have pushed "0.0" onto the :float stack
    When I execute the Nudge instruction "float_duplicate"
    Then the :float stack should be ["1.1", "0.0", "0.0"]
  
