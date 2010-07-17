Feature: Code 'list' manipulation
  In order to emulate the classical LISP-like languages
  As a modeler
  I want Nudge instructions for car, cdr, cons and related methods
    
    
  Scenario: code_position should find the first (0-based) point identical to the 2nd argument in the 1st arg 
    Given I have pushed "block {do a block {do b}}" onto the :code stack
    And I have pushed "do b" onto the :code stack
    When I execute the Nudge instruction "code_position"
    Then the original arguments should be gone
    And the :int stack should contain "3"
    
    
  Scenario: code_position should return [WHAT?!] if the 2nd arg is not found
    Given I have pushed "block {do a block {do b}}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    When I execute the Nudge instruction "code_position"
    Then the original arguments should be gone
    And the :int stack should contain "[WHAT?!]"
