Feature: Code reverse
  In order to manipulate code blocks as if they were trees and lists
  As a modeler
  I want Nudge to have a code_reverse instruction
  
  Scenario: reverses order of items in a simple block
    Given I have pushed "block {ref a ref b ref c}" onto the :code stack
    When I execute the Nudge instruction "code_reverse"
    Then "block {ref c ref b ref a}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: reverses order of backbone elements, not deeper items
    Given I have pushed "block {ref a block{ ref b ref c}}" onto the :code stack
    When I execute the Nudge instruction "code_reverse"
    Then "block { block{ ref b ref c} ref a}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: doesn't change an empty block
    Given I have pushed "block {}" onto the :code stack
    When I execute the Nudge instruction "code_reverse"
    Then "block {}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: doesn't change a non-block point
    Given I have pushed "ref g" onto the :code stack
    When I execute the Nudge instruction "code_reverse"
    Then "ref g" should be in position 0 of the :code stack
    And that stack's depth should be 1
