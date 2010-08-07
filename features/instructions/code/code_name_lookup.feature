#encoding: utf-8
Feature: code_name_lookup instruction
  In order to work with programs referring to values
  As a Nudge programmer
  I want a way of looking up a value
        
    
  Scenario: code_name_lookup instruction should push a new :code item based on a ref's value
    Given "x" is bound to a :float with value "7.89"
    And I have pushed "x" onto the :name stack
    When I execute the Nudge instruction "code_name_lookup"
    Then "value «float»\n«float»7.89" should be in position -1 of the :code stack
    And name "x" should be bound to "7.89"
    
    
  Scenario: code_name_lookup instruction should create an :error when the reference is unbound
    Given "x" is bound to a :float with value "7.89"
    And I have pushed "y" onto the :name stack
    When I execute the Nudge instruction "code_name_lookup"
    Then stack :code should have depth 0
    And the top :error should include "UnboundName"
