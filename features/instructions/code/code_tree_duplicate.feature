Feature: Code tree duplicate
  In order to manipulate code items something like stacks themselves
  As a Nudge programmer
  I want an instruction that duplicates the first backbone element of a block

  Scenario: in a simple block, the first element is duplicated
    Given I have pushed "block {ref a ref b}" onto the :code stack
    When I execute the Nudge instruction "code_tree_duplicate"
    Then "block {ref a ref a ref b}" should be in position -1 of the :code stack
  
  Scenario: in a nested block, the first backbone point is duped
    Given I have pushed "block {block {ref a ref b}}" onto the :code stack
    When I execute the Nudge instruction "code_tree_duplicate"
    Then "block {block {ref a ref b} block {ref a ref b}}" should be in position -1 of the :code stack
  
  Scenario: an empty block is untouched
    Given I have pushed "block {}" onto the :code stack
    When I execute the Nudge instruction "code_tree_duplicate"
    Then "block {}" should be in position -1 of the :code stack
  
  Scenario: a non-block is wrapped and duplicated
    Given I have pushed "ref g" onto the :code stack
    When I execute the Nudge instruction "code_tree_duplicate"
    Then "block {ref g ref g}" should be in position -1 of the :code stack
  
  Scenario: bad code generates an error
    Given I have pushed "foolish mortal" onto the :code stack
    When I execute the Nudge instruction "code_tree_duplicate"
    Then stack :code should have depth 0
    And the top :error should include "InvalidScript"
  
