#encoding: utf-8
Feature: code_define
  In order to work with programs referring to values
  As a modeler
  I want a code_define instruction
    
  Scenario: code_define instruction binds top :code item to a new ref
    Given I have pushed "block {}" onto the :code stack
    And I have pushed "x1" onto the :name stack
    When I execute the Nudge instruction "code_define"
    Then name "x1" should be bound to "block {}"
    And stack :name should have depth 0
    And stack :code should have depth 0
    
    
  Scenario: code_define instruction rebinds when given a name ref
    Given I have pushed "ref g" onto the :code stack
    And I have pushed "x1" onto the :name stack
    And "x1" is bound to a :code with value "block {}"
    When I execute the Nudge instruction "code_define"
    Then name "x1" should be bound to "ref g"
    And stack :name should have depth 0
    And stack :code should have depth 0
