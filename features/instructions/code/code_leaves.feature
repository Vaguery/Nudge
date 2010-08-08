Feature: code_leaves instruction
  In order to restructure Nudge blocks as if they were trees of code
  As a programmer
  I want a Nudge instruction that extracts all the non-block elements from a script
    
  Scenario: code_leaves should push the elements of a simple block onto the :code stack
    Given I have pushed "block {do a do b}" onto the :code stack
    When I execute the Nudge instruction "code_leaves"
    Then "do a" should be in position -2 of the :code stack
    And "do b" should be in position -1 of the :code stack
    And stack :code should have depth 2
    
    
  Scenario: code_leaves should push all the leaves, in depth-first order, onto the :code stack
    Given I have pushed "block {block {block {ref x} ref y} ref z}" onto the :code stack
    When I execute the Nudge instruction "code_leaves"
    Then "ref x" should be in position -3 of the :code stack
    And "ref y" should be in position -2 of the :code stack
    And "ref z" should be in position -1 of the :code stack
    And stack :code should have depth 3
    
    
  Scenario: code_leaves should leave non-block points alone
    Given I have pushed "ref g" onto the :code stack
    When I execute the Nudge instruction "code_leaves"
    Then "ref g" should be in position 0 of the :code stack
    And stack :code should have depth 1
    
    
  Scenario: code_leaves should remove empty blocks with no replacement
    Given I have pushed "block {}" onto the :code stack
    When I execute the Nudge instruction "code_leaves"
    Then stack :code should have depth 0
    
    
  Scenario: code_leaves should skip internal empty blocks as well
    Given I have pushed "block {ref a block {}}" onto the :code stack
    When I execute the Nudge instruction "code_leaves"
    Then stack :code should have depth 1
  
  