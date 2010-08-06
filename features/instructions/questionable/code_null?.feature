#encoding: utf-8
Feature: Code classification
  In order to build control structures and decisions based on :code item structure
  As a modeler
  I want Nudge instructions that classify and match :code
  
    
  # this is a stupid instruction :/
  Scenario: code_null? should be true if the argument is an empty block
    Given an interpreter with "block {}" on the :code stack
    When I execute "do code_null_q"
    Then "true" should be on top of the :bool stack
    And the argument should be gone
    
    
  Scenario: code_null_q should be false if the argument is a nonempty block
    Given an interpreter with "block {do int_add}" on the :code stack
    When I execute "do code_null_q"
    Then "false" should be on top of the :bool stack
    And the argument should be gone
    
    
  Scenario: code_null_q should be false if the argument is an instruction
    Given an interpreter with "do int_add" on the :code stack
    When I execute "do code_null_q"
    Then "false" should be on top of the :bool stack
    And the argument should be gone
    
    
  Scenario: code_null_q should be false if the argument is a reference
    Given an interpreter with "ref x" on the :code stack
    When I execute "do code_null_q"
    Then "false" should be on top of the :bool stack
    And the argument should be gone
    
    
  Scenario: code_null_q should be false if the argument is a value
    Given an interpreter with "value «int»\n«int» 78" on the :code stack
    When I execute "do code_null_q"
    Then "false" should be on top of the :bool stack
    And the argument should be gone
    
    
  Scenario: code_null_q should be false if the argument is unparseable
    Given an interpreter with "twas brillig" on the :code stack
    When I execute "do code_null_q"
    Then "false" should be on top of the :bool stack
    And the argument should be gone
    
