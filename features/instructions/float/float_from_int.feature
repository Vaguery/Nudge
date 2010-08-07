Feature: Float from int
  In order to convert numerics between the various types
  As a modeler
  I want Nudge to have an float_from_int instruction
  
  Scenario: simple
    Given I have pushed "11" onto the :int stack
    When I execute the Nudge instruction "float_from_int"
    Then "11.0" should be in position -1 of the :float stack
    And stack :int should have depth 0
    
    
  Scenario: negatives
    Given I have pushed "-121" onto the :int stack
    When I execute the Nudge instruction "float_from_int"
    Then "-121.0" should be in position -1 of the :float stack
    And stack :int should have depth 0
    
    
  Scenario: zero
    Given I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "float_from_int"
    Then "0.0" should be in position -1 of the :float stack
    And stack :int should have depth 0
    
    
  Scenario: minus zero (it can happen!)
    Given I have pushed "-0" onto the :int stack
    When I execute the Nudge instruction "float_from_int"
    Then "0.0" should be in position -1 of the :float stack
    And stack :int should have depth 0
    
    
  Scenario: large :int values may be approximated
    Given I have pushed "123456789012345678912345677890" onto the :int stack
    When I execute the Nudge instruction "float_from_int"
    Then something close to "123456789012345678912345677890.0" should be in position -1 of the :float stack
    And stack :int should have depth 0
    
    
  Scenario: huge :int values may be represented in scientific notation
    Given I have pushed "123456789012345678912345677890123456789012345678912345677890" onto the :int stack
    When I execute the Nudge instruction "float_from_int"
    Then "1.2345678901234567e+59" should be in position -1 of the :float stack
    And stack :int should have depth 0
    
    
  Scenario: extraordinarily big :int values will result in an :error
    Given I have pushed "1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" onto the :int stack
    When I execute the Nudge instruction "float_from_int"
    Then the top :error should include "NaN"
    And stack :int should have depth 0
    And stack :float should have depth 0
  