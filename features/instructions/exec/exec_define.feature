#encoding: utf-8
Feature: exec_define instruction
  In order to work with programs referring to values
  As a Nudge programmer
  I want a suite of _define instructions to link References to new values
  
  
  Scenario: exec_define instruction binds top :exec item to a new ref
    Given I have pushed "ref x" onto the :exec stack
    And I have pushed "n1" onto the :name stack
    When I execute the Nudge instruction "exec_define"
    Then the name "n1" should be bound to "ref x"
    And stack :exec should have depth 0
    And stack :name should have depth 0
    
    
  Scenario: exec_define instruction makes an :error when given a variable ref
    Given an interpreter with "do foo" on the :exec stack
    And the name "x1" on the :name stack
    And "x1" is bound to a variable
    When I execute the instruction "do exec_define"
    Then the arguments should disappear
    And an :error "attempted to exec_define a variable"
    
    
  Scenario: exec_define instruction rebinds when given a name ref
    Given an interpreter with "do foo" on the :exec stack
    And the name "x1" on the :name stack
    And "x1" is bound to the :int "8"
    When I execute the instruction "do exec_define"
    Then the arguments should disappear
    And the name "x1" should be bound to a value equal to the old :exec item
