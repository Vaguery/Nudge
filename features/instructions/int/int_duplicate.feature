Feature: Int duplicate
  In order to make extra copies of stuff I'm manipulating
  As a modeler
  I want Nudge to have a suite of instructions for making copies of the top items on stacks

  Scenario: it makes a copy of the top thing
    Given I have pushed "11" onto the :int stack
    And I have pushed "-2" onto the :int stack
    When I execute the Nudge instruction "int_duplicate"
    Then the :int stack should be ["11", "-2", "-2"]
  
