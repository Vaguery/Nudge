Feature: exec_y instruction
  In order to implement LISP-like recursive combinators
  As a modeler
  I want Nudge to include S, K and Y combinator instructions
    
    
  Scenario: exec_y instruction pushes a recursive macro onto :exec
    Given I have pushed "do A" onto the :exec stack
    When I execute the Nudge instruction "exec_y"
    Then "do A" should be in position -1 of the :exec stack
    And "block {do exec_y do A}" should be in position -2 of the :exec stack  
    And stack :exec should have depth 2
