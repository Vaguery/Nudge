Feature: Code tree maxdepth
  In order to manipulate and measure complex code objects
  As a modeler
  I want code_tree_maxdepth to tell me how deep the tree of a given :code item is

  Scenario: for an atom it's 1
    Given I have pushed "ref p" onto the :code stack
    When I execute the Nudge instruction "code_tree_maxdepth"
    Then "1" should be in position -1 of the :int stack
    And stack :code should have depth 0
  
  Scenario: for an empty block it's 1
    Given I have pushed "block {}" onto the :code stack
    When I execute the Nudge instruction "code_tree_maxdepth"
    Then "1" should be in position -1 of the :int stack
    And stack :code should have depth 0
  
  Scenario: for a flat block it's 2
    Given I have pushed "block {ref h}" onto the :code stack
    When I execute the Nudge instruction "code_tree_maxdepth"
    Then "2" should be in position -1 of the :int stack
    And stack :code should have depth 0
  
  Scenario: for a nested block it's the max of the sum of the results you'd get traversing the whole tree
    Given I have pushed "block {block {ref h} block {ref g block {ref n}}}" onto the :code stack
    When I execute the Nudge instruction "code_tree_maxdepth"
    Then "4" should be in position -1 of the :int stack
    And stack :code should have depth 0
    
  Scenario: bad code generates an :error
    Given I have pushed "hbskakdsasdajnd k" onto the :code stack
    When I execute the Nudge instruction "code_tree_maxdepth"
    Then stack :code should have depth 0
    And the top :error should include "InvalidScript"
