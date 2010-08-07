Feature: Proportion from ints
  In order to build proportions from pairs of calculated integers
  As a modeler
  I want Nudge to have a proportion_from_ints method
  
  
  Scenario: both positive
    Given I have pushed "91" onto the :int stack
    And I have pushed "100" onto the :int stack
    When I execute the Nudge instruction "proportion_from_ints"
    Then "0.91" should be in position -1 of the :proportion stack
    And stack :int should have depth 0
  
  
  Scenario: both negative
    Given I have pushed "-91" onto the :int stack
    And I have pushed "-100" onto the :int stack
    When I execute the Nudge instruction "proportion_from_ints"
    Then "0.91" should be in position -1 of the :proportion stack
    And stack :int should have depth 0
  
  
  Scenario: one is negative
    Given I have pushed "-91" onto the :int stack
    And I have pushed "100" onto the :int stack
    When I execute the Nudge instruction "proportion_from_ints"
    Then "0.0" should be in position -1 of the :proportion stack
    And stack :int should have depth 0
  
  
  Scenario: if the first arg is larger, it should cap at 1.0
    Given I have pushed "100" onto the :int stack
    And I have pushed "91" onto the :int stack
    When I execute the Nudge instruction "proportion_from_ints"
    Then "1.0" should be in position -1 of the :proportion stack
    And stack :int should have depth 0
  
  
  Scenario: if the first arg is larger, and the signs are inverted, it should floor at 0.0
    Given I have pushed "-100" onto the :int stack
    And I have pushed "91" onto the :int stack
    When I execute the Nudge instruction "proportion_from_ints"
    Then "0.0" should be in position -1 of the :proportion stack
    And stack :int should have depth 0
    
    
  Scenario: if the second is 0, an :error is pushed
    Given I have pushed "-100" onto the :int stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "proportion_from_ints"
    Then the top :error should include "NaN"
    And stack :int should have depth 0
    And stack :proportion should have depth 0
    
  
  