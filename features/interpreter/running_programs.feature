#encoding: utf-8

Feature: Expected outcomes
  In order trust my results
  As a Nudge user
  I want basic programs to produce expected outcomes
  
  
  Scenario: lists of blocks
    Given the blueprint "block {block {block {}} block {}}" 
    When I run the interpreter
    Then the execution counter should be 4
    And stack :exec should have depth 0
  
  
  Scenario: block element order
    Given the blueprint "block {ref a ref b ref c}"
    When I run the interpreter
    Then stack :name should have depth 3
    And "c" should be in position -3 of the :name stack
    And "b" should be in position -2 of the :name stack
    And "a" should be in position -1 of the :name stack
    And the execution counter should be 4
    
    
  Scenario: values
    Given the blueprint "value «int» \n«int» 12"
    When I run the interpreter
    Then stack :int should have depth 1
    And "12" should be in position -1 of the :int stack
    And the execution counter should be 1
    
  
  
  
  

  
