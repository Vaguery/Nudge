Feature: Code 'list' manipulation
  In order to emulate the classical LISP-like languages
  As a modeler
  I want Nudge instructions for car, cdr, cons and related methods
    
    
  Scenario: code_replace_nth_point should replace the nth point (0-based) of :code arg1 with :code arg2
    Given I have pushed "block {do a block {do b}}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "code_replace_nth_point"
    Then "block {do a ref x}" should be in position -1 of the :code stack
    And stack :int should have depth 0 
    
    
  Scenario: code_replace_nth_point should take n modulo the number of points in the arg1 (0-based)
    Given I have pushed "block {do a block {do b}}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    And I have pushed "31" onto the :int stack
    When I execute the Nudge instruction "code_replace_nth_point"
    Then "block {do a block {ref x}}" should be in position -1 of the :code stack
    And stack :int should have depth 0
    
    
    Scenario: code_replace_nth_point should return an :error if arg1 can't be parsed
      Given an interpreter with "kjkdksjfdasdf" on the :code stack
      And "ref x" on the :code stack above that
      And "1" on the :int stack
      When I execute "do code_replace_nth_point"
      Then the original arguments should be gone
      And the :error stack should contain "code_replace_nth_point cannot parse an argument"


    Scenario: code_replace_nth_point should return an :error if arg2 can't be parsed
      Given an interpreter with "block {}" on the :code stack
      And "kjnskdjnlasjdf" on the :code stack above that
      And "1" on the :int stack
      When I execute "do code_replace_nth_point"
      Then the original arguments should be gone
      And the :error stack should contain "code_replace_nth_point cannot parse an argument"
    