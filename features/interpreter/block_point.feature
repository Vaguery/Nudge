Feature: Block point execution
  In order to manipulate subroutines and complex junk like that there
  As a Nudge programmer
  I want the interpreter to act like Push3 did with block statements
  
  
  Scenario: flat blocks get shattered back onto :exec
    Given I have pushed "block {ref a ref b ref c}" onto the :exec stack
    When I take one execution step
    Then stack :exec should have depth 3
    And "ref c" should be in position -1 of the :exec stack
    And "ref b" should be in position -2 of the :exec stack
    And "ref a" should be in position -3 of the :exec stack
    And the execution counter should be 1
    
    
  Scenario: empty blocks disappear
    Given I have pushed "block {}" onto the :exec stack
    When I take one execution step
    Then stack :exec should have depth 0
    And the execution counter should be 1
    
    
  Scenario: only the backbone of a block should be shattered, not subtrees
    Given I have pushed "block {block {ref a ref b} block {ref c}}" onto the :exec stack
    When I take one execution step
    Then stack :exec should have depth 2
    And "block {ref c}" should be in position -1 of the :exec stack
    And "block {ref a ref b}" should be in position -2 of the :exec stack
    And the execution counter should be 1
    
