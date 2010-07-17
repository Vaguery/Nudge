Feature: Code 'list' manipulation
  In order to emulate the classical LISP-like languages
  As a modeler
  I want Nudge instructions for car, cdr, cons and related methods
    
    
  Scenario: code_nth_point should return the nth point of a program (0-based)
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "code_nth_point"
    Then the original arguments should be gone
    And the :code stack should contain "do b"
    
    
  Scenario: code_nth_point should take n modulo the number of points
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "7" onto the :int stack
    When I execute the Nudge instruction "code_nth_point"
    Then the original arguments should be gone
    And the :code stack should contain "do c"
    
    
  Scenario: code_nth_point should take arg2 = 0 to mean the first point
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "code_nth_point"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a do b do c}"
    
    
  Scenario: code_nth_point should work as expected for negative arguments
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "-1" onto the :int stack
    When I execute the Nudge instruction "code_nth_point"
    Then the original arguments should be gone
    And the :code stack should contain "do c"