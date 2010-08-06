Feature: code_bundle
  In order to wrap multiple items from the :code stack in a single block
  As a modeler
  I want a code_bundle instruction
  
  
  Scenario: code_bundle(1) should return a block with the top item from :code in a new wrapper block
    Given I have pushed "ref x" onto the :code stack
    And I have pushed "1" onto the :int stack
    When I execute the Nudge instruction "code_bundle"
    Then "block { ref x }" should be in position 0 of the :code stack
    And stack :code should have depth 1
    And stack :int should have depth 0
  
  
  Scenario: code_bundle(2) should return a block with the top 2 items from :code in a single block
    Given I have pushed "ref x" onto the :code stack
    And I have pushed "do a" onto the :code stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "code_bundle"
    Then "block { ref x do a}" should be in position 0 of the :code stack
    And stack :code should have depth 1
    And stack :int should have depth 0
    
    
  Scenario: code_bundle(0) should push an empty block
    Given I have pushed "ref x" onto the :code stack
    And I have pushed "do a" onto the :code stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "code_bundle"
    Then "block {}" should be in position -1 of the :code stack
    And stack :code should have depth 3
    And stack :int should have depth 0
    
    
    
  Scenario: code_bundle(-12) should pop the :int but give no :code result
    Given I have pushed "ref x" onto the :code stack
    And I have pushed "-12" onto the :int stack
    When I execute the Nudge instruction "code_bundle"
    Then "ref x" should be in position -1 of the :code stack
    And stack :code should have depth 1
    And stack :int should have depth 0
    
    
    
  Scenario: code_bundle(1) should wrap items even if they're blocks already
    Given I have pushed "block {}" onto the :code stack
    And I have pushed "1" onto the :int stack
    When I execute the Nudge instruction "code_bundle"
    Then "block { block {} }" should be in position 0 of the :code stack
    And stack :code should have depth 1
    And stack :int should have depth 0
    
  
  
  Scenario: code_bundle(more items than on stack) should wrap the whole stack in one item
    Given I have pushed "ref x" onto the :code stack
    And I have pushed "ref y" onto the :code stack
    And I have pushed "ref z" onto the :code stack
    And I have pushed "33" onto the :int stack
    When I execute the Nudge instruction "code_bundle"
    Then "block { ref x ref y ref z}" should be in position 0 of the :code stack
    And stack :code should have depth 1
    And stack :int should have depth 0
    
