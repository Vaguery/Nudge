Feature: Code 'list' manipulation
  In order to emulate the classical LISP-like languages
  As a modeler
  I want Nudge instructions for car, cdr, cons and related methods
  
    
  Scenario: code_list should return a block with both arguments in order as root elements
    Given I have pushed "ref x" onto the :code stack
    And I have pushed "do a" onto the :code stack
    When I execute the Nudge instruction "code_list"
    Then the original arguments should be gone
    And the :code stack should contain "block {ref x do a}"
    
    
  Scenario: code_list should work as expected with block arguments
    Given I have pushed "block {ref x}" onto the :code stack
    And I have pushed "block {do a}" onto the :code stack
    When I execute the Nudge instruction "code_list"
    Then the original arguments should be gone
    And the :code stack should contain "block {block {ref x} block {do a}}"
