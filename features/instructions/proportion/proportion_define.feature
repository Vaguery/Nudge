#encoding: utf-8
Feature: proportion_define
  In order to work with programs referring to values
  As a modeler
  I want a proportion_define instruction
    
  Scenario: proportion_define instruction binds top :proportion item to a new ref
    Given I have pushed "0.111" onto the :proportion stack
    And I have pushed "x1" onto the :name stack
    When I execute the Nudge instruction "proportion_define"
    Then name "x1" should be bound to "0.111"
    And stack :name should have depth 0
    And stack :proportion should have depth 0
    
    
  Scenario: proportion_define instruction rebinds when given a name ref
    Given I have pushed "0.444" onto the :proportion stack
    And I have pushed "x1" onto the :name stack
    And "x1" is bound to a :proportion with value "0.111"
    When I execute the Nudge instruction "proportion_define"
    Then name "x1" should be bound to "0.444"
    And stack :name should have depth 0
    And stack :proportion should have depth 0
