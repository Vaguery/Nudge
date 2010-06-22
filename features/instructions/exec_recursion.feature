Feature: Exec recursion
  In order to implement LISP-like recursive combinators
  As a modeler
  I want Nudge to include S, K and Y combinator instructions
  
  
  Scenario: exec_k instruction should remove the second item from :exec
    Given an interpreter with "do foo" on the :exec stack
    And "ref y" on :exec above that
    When I execute the instruction "do exec_k"
    Then the "do foo" item should have disappeared
    And the "ref y" item left on top
    
    
    
    
    
    
  Scenario: exec_s instruction recombines the top 3 items on :exec into 3 new items 
    Given an interpreter with "ref C" on the :exec stack
    And "ref B" on :exec above that
    And "ref A" on the top
    When I execute the instruction "do exec_s"
    Then the top item on :exec should be "ref A"
    And the second item on :exec should be "ref C"
    And the third item on :exec should be "block {ref B ref C}"
    
    
    
    
    
    
  Scenario: exec_y instruction pushes a recursive macro onto :exec 
    Given an interpreter with "do A" on the :exec stack
    When I execute the instruction "do exec_y"
    Then the top item on :exec should be "do A"
    And the second item should be "block {do exec_y do A}"
