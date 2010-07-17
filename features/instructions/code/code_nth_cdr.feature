Feature: Code 'list' manipulation
  In order to remove items from Nudge blocks as if they were LISP lists
  As someone fond of the Push3 syntax
  I want a 'code_nth_cdr' Nudge instruction
    
    
  Scenario: code_nth_cdr should return the nth cdr of a block
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "code_nth_cdr"
    Then "block {do c}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    And stack :int should have depth 0
    
    
  Scenario: code_nth_cdr should not change the result if the :int is 0
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "code_nth_cdr"
    Then "block {do a do b do c}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    And stack :int should have depth 0
    
    
  Scenario: code_nth_cdr should wrap a statement in a block first
    Given I have pushed "do int_add" onto the :code stack
    And I have pushed "1" onto the :int stack
    When I execute the Nudge instruction "code_nth_cdr"
    Then "block {}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    And stack :int should have depth 0

    
  Scenario: code_nth_cdr should remove the entire block's backbone if n is the same as its length
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "3" onto the :int stack
    When I execute the Nudge instruction "code_nth_cdr"
    Then "block {}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    And stack :int should have depth 0
    
    
  Scenario: code_nth_cdr should remove the entire block's backbone if n is larger than its length
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "4" onto the :int stack
    When I execute the Nudge instruction "code_nth_cdr"
    Then "block {}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    And stack :int should have depth 0
    
    
  Scenario: code_nth_cdr should return the arg intact for non-positive n
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "-4" onto the :int stack
    When I execute the Nudge instruction "code_nth_cdr"
    Then "block {do a do b do c}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    And stack :int should have depth 0
    