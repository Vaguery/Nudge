Feature: exec_k
  In order to implement LISP-like recursive combinators
  As a modeler
  I want Nudge to include S, K and Y combinator instructions
  
  
  Scenario: exec_k instruction should remove the second item from :exec
    Given I have pushed "do bool_and" onto the :exec stack
    And I have pushed "ref y" onto the :exec stack
    When I execute the Nudge instruction "exec_k"
    Then "ref y" should be in position -1 of the :exec stack
    And stack :exec should have depth 1