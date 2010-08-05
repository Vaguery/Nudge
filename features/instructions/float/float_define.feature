#encoding: utf-8
Feature: float_define
  In order to work with programs referring to values
  As a modeler
  I want a float_define instruction
    
  Scenario: float_define instruction binds top :float item to a new ref
    Given I have pushed "12.34" onto the :float stack
    And I have pushed "x1" onto the :name stack
    When I execute the Nudge instruction "float_define"
    Then name "x1" should be bound to "12.34"
    And stack :name should have depth 0
    And stack :float should have depth 0
    
    
  Scenario: float_define instruction rebinds when given a name ref
    Given I have pushed "12.34" onto the :float stack
    And I have pushed "x1" onto the :name stack
    And "x1" is bound to a :float with value "99.99"
    When I execute the Nudge instruction "float_define"
    Then name "x1" should be bound to "12.34"
    And stack :name should have depth 0
    And stack :float should have depth 0
