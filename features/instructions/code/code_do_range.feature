#encoding: utf-8

Feature: code_do_range
  In order to create iteration and recursion
  As a modeler
  I want Nudge to include the Push3 code and exec iteration instructions
    
  Scenario: code_do_range should execute the top :code item for each integer in [n1, n2]
    Given I have pushed "block {ref a}" onto the :code stack
    And I have pushed "9" onto the :int stack
    And I have pushed "11" onto the :int stack
    When I execute the Nudge instruction "code_do_range"
    Then "block {ref a}" should be in position -1 of the :exec stack
    Then "block { value «int» value «int» do exec_do_range block {ref a}}\n«int» 10\n«int» 11" should be in position -2 of the :exec stack
    And stack :code should have depth 0
    And stack :int should have depth 1
    And "9" should be in position -1 of the :int stack
    
    
  Scenario: code_do_range should actually run the top :code item for each integer in [n1, n2]
    Given I have pushed "block {ref a}" onto the :code stack
    And I have pushed "do code_do_range" onto the :exec stack
    And I have pushed "9" onto the :int stack
    And I have pushed "11" onto the :int stack
    When I run the interpreter
    Then stack :name should have depth 3
    And stack :code should have depth 0
    And stack :int should have depth 3
    And "11" should be in position -1 of the :int stack
    And "10" should be in position -2 of the :int stack
    And "9" should be in position -3 of the :int stack
    
  
    
    
  Scenario: code_do_range should work fine with reversed indices
    Given I have pushed "block {ref a}" onto the :code stack
    And I have pushed "-4" onto the :int stack
    And I have pushed "-21" onto the :int stack
    When I execute the Nudge instruction "code_do_range"
    Then "block { value «int» value «int» do exec_do_range block {ref a}}\n«int» -5\n«int» -21" should be in position -1 of the :exec stack
    And stack :code should have depth 0
    And stack :int should have depth 1
    And "-4" should be in position -1 of the :int stack
    
    
  Scenario: code_do_range should run with reversed indices
    Given I have pushed "block {ref a}" onto the :code stack
    And I have pushed "do code_do_range" onto the :exec stack
    And I have pushed "33" onto the :int stack
    And I have pushed "31" onto the :int stack
    When I run the interpreter
    Then stack :name should have depth 3
    And stack :code should have depth 0
    And stack :int should have depth 3
    And "31" should be in position -1 of the :int stack
    And "32" should be in position -2 of the :int stack
    And "33" should be in position -3 of the :int stack
  
    
    
  Scenario: code_do_range should just replicate the code arg when the indices are identical
    Given I have pushed "block {ref a}" onto the :code stack
    And I have pushed "2" onto the :int stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "code_do_range"
    Then "block {ref a}" should be in position -1 of the :exec stack
    And stack :code should have depth 0
    And stack :int should have depth 1
    And "2" should be in position -1 of the :int stack
    
    
  Scenario: code_do_range pushes its counter value to :int
    Given I have pushed "block {ref a}" onto the :code stack
    And I have pushed "222" onto the :int stack
    And I have pushed "2121" onto the :int stack
    When I execute the Nudge instruction "code_do_range"
    Then "222" should be in position -1 of the :int stack
    
