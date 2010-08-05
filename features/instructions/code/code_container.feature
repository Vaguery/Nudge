Feature: Code 'list' manipulation
  In order to emulate the classical LISP-like languages
  As a modeler
  I want Nudge instructions for car, cdr, cons and related methods
    
    
  Scenario: code_container should return the first block that contains the 2nd arg in its root
    Given I have pushed "block {block {do a ref x}}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    When I execute the Nudge instruction "code_container"
    Then stack :code should have depth 1
    And "block {do a ref x}" should be in position -1 of the :code stack
    
    
  Scenario: code_container should return an empty block if the 2nd arg is not found
    Given I have pushed "block {block {do a ref x}}" onto the :code stack
    And I have pushed "ref z" onto the :code stack
    When I execute the Nudge instruction "code_container"
    Then stack :code should have depth 1
    And "block {}" should be in position -1 of the :code stack    
    
    
  Scenario: code_container should return the first block found by breadth-first search
    Given I have pushed "block {block {do a ref z} ref z}" onto the :code stack
    And I have pushed "ref z" onto the :code stack
    When I execute the Nudge instruction "code_container"
    Then stack :code should have depth 1
    And "block {block {do a ref z} ref z}" should be in position -1 of the :code stack    
    
    
  Scenario: code_container should return all associated block structure
    Given I have pushed "block {block {ref z block {} ref z} ref w}" onto the :code stack
    And I have pushed "ref z" onto the :code stack
    When I execute the Nudge instruction "code_container"
    Then stack :code should have depth 1
    And "block {ref z block {} ref z}" should be in position -1 of the :code stack    
    
    
  Scenario: code_container should return the correct footnotes
    Given I have pushed "block {block {value «int» ref x}} \n«int» 99" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    When I execute the Nudge instruction "code_container"
    Then stack :code should have depth 1
    And "block {value «int» ref x} \n«int» 99" should be in position -1 of the :code stack    
    
    
  Scenario: code_container should return the entire arg1 if they're identical
    Given I have pushed "block {block {value «int» ref x}} \n«int» 99" onto the :code stack
    And I have pushed "block {block {value «int» ref x}} \n«int» 99" onto the :code stack
    When I execute the Nudge instruction "code_container"
    Then stack :code should have depth 1
    And "block {block {value «int» ref x}} \n«int» 99" should be in position -1 of the :code stack    


  Scenario: code_container should return an :error if its arg1 can't be parsed
    Given an interpreter with "bbbbbbbbbbb" on the :code stack
    And "block {block {value «int» ref x}} \n«int» 99" above that
    When I execute "do code_container"
    Then the original arguments should be gone
    And the :error stack should contain "code_container cannot parse an argument"


  Scenario: code_container should return an :error if its arg2 can't be parsed
    Given an interpreter with "block {}" on the :code stack
    And "kjanskdjnaskld" above that
    When I execute "do code_container"
    Then the original arguments should be gone
    And the :error stack should contain "code_container cannot parse an argument"
  