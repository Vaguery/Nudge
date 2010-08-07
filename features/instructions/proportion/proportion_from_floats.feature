Feature: Proportion from floats
  In order to build proportions from pairs of calculated floats
  As a modeler
  I want Nudge to have a proportion_from_floats method
  
  
  Scenario: both positive
    Given I have pushed "78.0" onto the :float stack
    And I have pushed "100.0" onto the :float stack
    When I execute the Nudge instruction "proportion_from_floats"
    Then something close to "0.78" should be in position -1 of the :proportion stack
    And stack :float should have depth 0
  
  
  Scenario: both negative
    Given I have pushed "-91.1" onto the :float stack
    And I have pushed "-100.0" onto the :float stack
    When I execute the Nudge instruction "proportion_from_floats"
    Then something close to "0.911" should be in position -1 of the :proportion stack
    And stack :float should have depth 0
  
  
  Scenario: one is negative
    Given I have pushed "-1.0" onto the :float stack
    And I have pushed "100.0" onto the :float stack
    When I execute the Nudge instruction "proportion_from_floats"
    Then something close to "0.0" should be in position -1 of the :proportion stack
    And stack :float should have depth 0
  
  
  Scenario: if the first arg is larger, it should cap at 1.0
    Given I have pushed "3.9" onto the :float stack
    And I have pushed "1.3" onto the :float stack
    When I execute the Nudge instruction "proportion_from_floats"
    Then something close to "1.0" should be in position -1 of the :proportion stack
    And stack :float should have depth 0
  
  
  Scenario: if the first arg is larger, and the signs are inverted, it should floor at 0.0
    Given I have pushed "-100.0" onto the :float stack
    And I have pushed "91.0" onto the :float stack
    When I execute the Nudge instruction "proportion_from_floats"
    Then something close to "0.0" should be in position -1 of the :proportion stack
    And stack :float should have depth 0


  Scenario: if the second is 0.0, an :error is pushed
    Given I have pushed "-1.0" onto the :float stack
    And I have pushed "0.0" onto the :float stack
    When I execute the Nudge instruction "proportion_from_floats"
    Then the top :error should include "NaN"
    And stack :float should have depth 0
    And stack :proportion should have depth 0
