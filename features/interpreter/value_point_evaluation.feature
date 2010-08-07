Feature: Value point evaluation
  In order to use literals in my algorithms
  As a modeler
  I want Nudge to handle value points as if they were constants


  Scenario: value handling when a stack exists
    Given I have pushed "value «int»\n«int» 8" onto the :exec stack
    And I have pushed "99" onto the :int stack
    When I take one execution step
    Then stack :exec should have depth 0
    And "8" should be in position -1 of the :int stack
    And "99" should be in position -2 of the :int stack
    And the execution counter should be 1
    
    
  Scenario: value handling when a stack does not exist
    Given I have pushed "value «foo» \n«foo» bar" onto the :exec stack
    When I take one execution step
    Then stack :exec should have depth 0
    And "bar" should be in position -1 of the :foo stack
    And the execution counter should be 1
    
    
  Scenario: value handling when there is no footnote
    Given I have pushed "value «missing»" onto the :exec stack
    When I take one execution step
    Then stack :exec should have depth 0
    And stack :missing should have depth 0
    And the top :error should include "EmptyValue"
