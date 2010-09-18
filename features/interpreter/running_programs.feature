#encoding: utf-8

Feature: Expected outcomes
  In order trust my results
  As a Nudge user
  I want basic programs to produce expected outcomes
  
  
  Scenario: lists of blocks
    Given I have pushed "block {block {block {}} block {}}" onto the :exec stack 
    When I run the interpreter
    Then the execution counter should be 4
    And stack :exec should have depth 0
  
  
  Scenario: block element order
    Given I have pushed "block {ref a ref b ref c}" onto the :exec stack
    When I run the interpreter
    Then stack :name should have depth 3
    And "c" should be in position -1 of the :name stack
    And "b" should be in position -2 of the :name stack
    And "a" should be in position -3 of the :name stack
    And the execution counter should be 4
  
  
  Scenario: values
    Given I have pushed "value «int»\n«int» 3" onto the :exec stack
    When I run the interpreter
    Then stack :int should have depth 1
    And "3" should be in position -1 of the :int stack
    And the execution counter should be 1
