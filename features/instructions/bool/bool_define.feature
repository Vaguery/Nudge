#encoding: utf-8
Feature: bool_define
  In order to work with programs referring to values
  As a modeler
  I want a bool_define instruction
    
  Scenario: bool_define instruction binds top :bool item to a new ref
    Given I have pushed "false" onto the :bool stack
    And I have pushed "x1" onto the :name stack
    When I execute the Nudge instruction "bool_define"
    Then name "x1" should be bound to "false"
    And stack :name should have depth 0
    And stack :bool should have depth 0
    
    
  Scenario: bool_define instruction rebinds when given a name ref
    Given I have pushed "false" onto the :bool stack
    And I have pushed "x1" onto the :name stack
    And "x1" is bound to a :bool with value "true"
    When I execute the Nudge instruction "bool_define"
    Then name "x1" should be bound to "false"
    And stack :name should have depth 0
    And stack :bool should have depth 0
