#encoding: utf-8
Feature: int_define
  In order to work with programs referring to values
  As a modeler
  I want a int_define instruction
    
  Scenario: int_define instruction binds top :int item to a new ref
    Given I have pushed "12" onto the :int stack
    And I have pushed "x1" onto the :name stack
    When I execute the Nudge instruction "int_define"
    Then name "x1" should be bound to "12"
    And stack :name should have depth 0
    And stack :int should have depth 0
    
    
  Scenario: int_define instruction rebinds when given a name ref
    Given I have pushed "424" onto the :int stack
    And I have pushed "x1" onto the :name stack
    And "x1" is bound to a :int with value "111"
    When I execute the Nudge instruction "int_define"
    Then name "x1" should be bound to "424"
    And stack :name should have depth 0
    And stack :int should have depth 0
