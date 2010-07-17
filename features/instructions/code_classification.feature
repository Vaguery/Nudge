#encoding: utf-8
Feature: Code classification
  In order to build control structures and decisions based on :code item structure
  As a modeler
  I want Nudge instructions that classify and match :code
  
  
  Scenario: code_atom? should be true if the argument is an instruction
    Given I have pushed "do a" onto the :code stack
    When I execute the Nudge instruction "code_atom?"
    Then "true" should be in position 0 of the :bool stack
    And stack :code should have depth 0
  
  
  Scenario: code_atom? should be true if the argument is a reference
    Given I have pushed "ref a" onto the :code stack
    When I execute the Nudge instruction "code_atom?"
    Then "true" should be in position 0 of the :bool stack
    And stack :code should have depth 0
    
    
  Scenario: code_atom? should be true if the argument is value
    Given I have pushed "value «int»\n«int» 8" onto the :code stack
    When I execute the Nudge instruction "code_atom?"
    Then "true" should be in position 0 of the :bool stack
    And stack :code should have depth 0
    
    
  Scenario: code_atom? should be true if the argument is value that contains a block
    Given I have pushed "value «code»\n«code» block {}" onto the :code stack
    When I execute the Nudge instruction "code_atom?"
    Then "true" should be in position 0 of the :bool stack
    And stack :code should have depth 0
    
    
  Scenario: code_atom? should be false if the argument is a block
    Given I have pushed "block {}" onto the :code stack
    When I execute the Nudge instruction "code_atom?"
    Then "false" should be in position 0 of the :bool stack
    And stack :code should have depth 0
    
    
  Scenario: code_atom? should be false if the argument is unparseable
    Given I have pushed "i am not valid" onto the :code stack
    When I execute the Nudge instruction "code_atom?"
    Then "false" should be in position 0 of the :bool stack
    And stack :code should have depth 0
    
    
    
    
    
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
    
    
    
    
    
    
  Scenario: code_parses_q should be true if the :code can be parsed 
    Given an interpreter with "block {do x block {do y}}" on the :code stack
    When I execute "do code_parses_q"
    Then "true" should be on top of the :bool stack
    And the argument should be gone
  
  
  Scenario: code_parses_q should be flase if the :code cannot be parsed 
    Given an interpreter with "block {do x block {do y" on the :code stack
    When I execute "do code_parses_q"
    Then "false" should be on top of the :bool stack
    And the argument should be gone