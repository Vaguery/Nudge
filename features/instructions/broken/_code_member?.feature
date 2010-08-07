#encoding: utf-8
Feature: Code classification
  In order to build control structures and decisions based on :code item structure
  As a modeler
  I want Nudge instructions that classify and match :code
  
    
  Scenario: code_member_q should be true if the 2nd argument is in the root of the 1st
    Given an interpreter with "block {do x}" on the :code stack
    And "do x" on top of that
    When I execute "do code_member_q"
    Then "true" should be on top of the :bool stack
    And the arguments should be gone
    
    
  Scenario: code_member_q should be true if the 2nd argument is the same as the first
    Given an interpreter with "block {do x}" on the :code stack
    And "block {do x}" on top of that
    When I execute "do code_member_q"
    Then "true" should be on top of the :bool stack
    And the arguments should be gone
    
    
  Scenario: code_member_q should be false if the 2nd argument is inside the 1st but not in the root
    Given an interpreter with "block {do x block {do y}}" on the :code stack
    And "do y" on top of that
    When I execute "do code_member_q"
    Then "false" should be on top of the :bool stack
    And the arguments should be gone
    
    
  Scenario: code_member_q should be false if the 2nd argument is not inside the 1st 
    Given an interpreter with "block {do x block {do y}}" on the :code stack
    And "ref x" on top of that
    When I execute "do code_member_q"
    Then "false" should be on top of the :bool stack
    And the arguments should be gone
    
