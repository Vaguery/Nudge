Feature: Reference point
  In order to manipulate abstract variables in a coherent way
  As a modeler
  I want Nudge to use names like Push3 did
  
  
  Scenario: execution of a bound variable doesn't take extra steps
    Given I have pushed "ref x" onto the :exec stack
    And I have bound "x" to an :int with value "99"
    When I take one execution step
    Then stack :exec should have depth 0
    And "99" should be in position -1 of the :int stack
    And the execution counter should be 1
    
    
  Scenario: execution of an unbound variable shifts it to the :name stack
    Given I have pushed "ref x" onto the :exec stack
    When I take one execution step
    Then stack :exec should have depth 0
    And "x" should be in position -1 of the :name stack
    And the execution counter should be 1
