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


    Scenario: code_position should return an error if arg1 can't be parsed
      Given an interpreter with "88888888" on the :code stack
      And "ref x" on the :code stack above that
      When I execute "do code_position"
      Then the original arguments should be gone
      And the :error stack should contain "code_position cannot parse an argument"


    Scenario: code_position should return an error if arg2 can't be parsed
      Given an interpreter with "block {}" on the :code stack
      And "8887766" on the :code stack above that
      When I execute "do code_position"
      Then the original arguments should be gone
      And the :error stack should contain "code_position cannot parse an argument"

