Feature: Code 'list' manipulation
  In order to emulate the classical LISP-like languages
  As a modeler
  I want Nudge instructions for car, cdr, cons and related methods
    
    
  Scenario: code_nth should return the nth backbone element (0-based) of a :code item
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "code_nth"
    Then the original arguments should be gone
    And the :code stack should contain "do a"
    
    
  Scenario: code_nth should take n modulo the number of items in the backbone
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "5" onto the :int stack
    When I execute the Nudge instruction "code_nth"
    Then the original arguments should be gone
    And the :code stack should contain "do c"
      
      
  Scenario: code_nth should not affect a non-block argument
    Given I have pushed "do int_add" onto the :code stack
    And I have pushed "33" onto the :int stack
    When I execute the Nudge instruction "code_nth"
    Then the original arguments should be gone
    And the :code stack should contain "do int_add"
