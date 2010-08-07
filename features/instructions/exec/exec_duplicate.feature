Feature: Exec duplicate
  In order to make extra copies of stuff I'm manipulating
  As a modeler
  I want Nudge to have a suite of instructions for making copies of the top items on stacks

  Scenario: it makes a copy of the top thing
    Given I have pushed "ref a" onto the :exec stack
    And I have pushed "ref b" onto the :exec stack
    When I execute the Nudge instruction "exec_duplicate"
    Then the :exec stack should be ["ref a", "ref b", "ref b"]
    And there should be no repeated object_ids in the :exec stack
  
