Feature: exec_s instruction
  In order to implement LISP-like recursive combinators
  As a modeler
  I want Nudge to include S, K and Y combinator instructions
    
    
  Scenario: exec_s instruction recombines the top 3 items on :exec into 3 new items
    Given I have pushed "ref C" onto the :exec stack
    And I have pushed "ref B" onto the :exec stack
    And I have pushed "ref A" onto the :exec stack
    When I execute the Nudge instruction "exec_s"
    Then stack :exec should have depth 3
    Then "ref A" should be in position -1 of the :exec stack
    And "ref C" should be in position -2 of the :exec stack
    And "block {ref B ref C}" should be in position -3 of the :exec stack
