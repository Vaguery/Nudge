Feature: Code 'list' manipulation
  In order to emulate the classical LISP-like languages
  As a modeler
  I want Nudge instructions for car, cdr, cons and related methods
    
    
  Scenario: code_replace_nth_point should replace the nth point (0-based) of :code arg1 with :code arg2
    Given I have pushed "block {do a block {do b}}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "code_replace_nth_point"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a ref x}"
    
    
  Scenario: code_replace_nth_point should take n modulo the number of points in the arg1 (0-based)
    Given I have pushed "block {do a block {do b}}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    And I have pushed "31" onto the :int stack
    When I execute the Nudge instruction "code_replace_nth_point"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a block {ref x}}"