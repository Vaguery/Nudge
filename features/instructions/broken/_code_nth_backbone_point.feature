Feature: code_nth_backbone_point instruction
  In order to emulate the classical LISP-like languages
  As a modeler
  I want Nudge instructions for car, cdr, cons and related methods
    
    
  Scenario: code_nth_backbone_point should return the nth backbone element (0-based) of a :code item
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "code_nth_backbone_point"
    Then stack :int should have depth 0
    And stack :code should have depth 1
    And the :code stack should contain "do a"
    
    
  Scenario: code_nth_backbone_point should take n modulo the number of items in the backbone
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "5" onto the :int stack
    When I execute the Nudge instruction "code_nth_backbone_point"
    Then the original arguments should be gone
    And the :code stack should contain "do c"
      
      
  Scenario: code_nth_backbone_point should not affect a non-block argument
    Given I have pushed "do int_add" onto the :code stack
    And I have pushed "33" onto the :int stack
    When I execute the Nudge instruction "code_nth_backbone_point"
    Then the original arguments should be gone
    And the :code stack should contain "do int_add"

    Scenario: code_nth_backbone_point should create an error if an empty block is the arg
      Given an interpreter with "block {}" on the :code stack
      And "2" on the :int stack
      When I execute "code_nth_backbone_point"
      Then the original arguments should be gone
      And the :error stack should contain "code_nth cannot work on empty blocks"
    