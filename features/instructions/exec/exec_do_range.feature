#encoding: utf-8
Feature: exec_do_range instruction
  In order to create iteration and recursion
  As a modeler
  I want Nudge to include the Push3 code and exec iteration instructions

    
  Scenario: exec_do_range should execute the top :exec item for each integer in [n1, n2]
    Given I have pushed "do int_add" onto the :exec stack
    And I have pushed "3" onto the :int stack
    And I have pushed "5" onto the :int stack
    When I execute the Nudge instruction "exec_do_range"
    Then "block { value «int» value «int» do exec_do_range do int_add }\n«int»4\n«int»5" should be in position -1 of the :exec stack
    And stack :int should have depth 1
    And "3" should be in position -1 of the :int stack
    
    
  Scenario: exec_do_range should work fine with reversed indices
    Given I have pushed "do foo" onto the :exec stack
    And I have pushed "-13" onto the :int stack
    And I have pushed "-15" onto the :int stack
    When I execute the Nudge instruction "exec_do_range"
    Then "block { value «int» value «int» do exec_do_range do foo }\n«int»-14\n«int»-15" should be in position -1 of the :exec stack
    And stack :int should have depth 1
    And "-13" should be in position -1 of the :int stack
    
    
  Scenario: exec_do_range should just replicate the code arg when the indices are identical
    Given I have pushed "do foo" onto the :exec stack
    And I have pushed "44" onto the :int stack
    And I have pushed "44" onto the :int stack
    When I execute the Nudge instruction "exec_do_range"
    Then "do foo" should be in position -1 of the :exec stack
    And stack :int should have depth 1
    And "44" should be in position -1 of the :int stack
    
    
  Scenario: exec_do_range pushes its counter value to :int
    Given I have pushed "do foo" onto the :exec stack
    And I have pushed "44" onto the :int stack
    And I have pushed "49" onto the :int stack
    When I execute the Nudge instruction "exec_do_range"
    And "44" should be in position -1 of the :int stack
