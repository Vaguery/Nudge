#encoding: utf-8

Feature: Iteration control structures
  In order to create iteration and recursion
  As a modeler
  I want Nudge to include the Push3 code and exec instructions
  
  Scenario: code_do_count should build a macro that will execute the :code item n times
    Given I have pushed "block {ref x}" onto the :code stack
    And I have pushed "9" onto the :int stack
    When I execute the Nudge instruction "code_do_count"
    Then "block { value «int» do exec_do_count block {ref x}}\n«int» 8" should be in position -1 of the :exec stack
    And stack :code should have depth 0
    And stack :int should have depth 0
    
    
  Scenario: code_do_count stops building its macro when n==1
    Given I have pushed "block {ref x}" onto the :code stack
    And I have pushed "1" onto the :int stack
    When I execute the Nudge instruction "code_do_count"
    Then "block{ ref x}" should be in position -1 of the :exec stack
    And stack :code should have depth 0
    And stack :int should have depth 0
    
    
  Scenario: code_do_count throws away the code for a 0 count
    Given I have pushed "block {ref x}" onto the :code stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "code_do_count"
    Then stack :exec should have depth 0
    And stack :code should have depth 0
    And stack :int should have depth 0
    
    
  Scenario: code_do_count creates an :error for a negative count
    Given I have pushed "block {ref x}" onto the :code stack
    And I have pushed "-1" onto the :int stack
    When I execute the Nudge instruction "code_do_count"
    Then stack :exec should have depth 0
    And stack :code should have depth 0
    And stack :int should have depth 0
    And "code_do_count called with negative counter" should be in position -1 of the :error stack