Feature: Code container
  In order to manipulate complex :code trees
  As a modeler
  I want code_container to find the enclosing block for a piece of a script
    
  
  Scenario: code_container should return an :error if arg1 isn't a block
    Given I have pushed "ref g" onto the :code stack
    And I have pushed "do int_add" onto the :code stack
    When I execute the Nudge instruction "code_container"
    Then stack :code should have depth 0
    And the top :error should include "InvalidIndex"
  
  
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
    
    
  # modified: had been "breadth-first search"
  Scenario: code_container should return the first block found by depth-first search
    Given I have pushed "block {block {do a ref z} ref z}" onto the :code stack
    And I have pushed "ref z" onto the :code stack
    When I execute the Nudge instruction "code_container"
    Then stack :code should have depth 1
    And "block {do a ref z}" should be in position -1 of the :code stack    
    
    
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
    
    
  Scenario: code_container should return an empty block if they're identical
    Given I have pushed "block {block {value «int» ref x}} \n«int» 99" onto the :code stack
    And I have pushed "block {block {value «int» ref x}} \n«int» 99" onto the :code stack
    When I execute the Nudge instruction "code_container"
    Then stack :code should have depth 1
    And "block { }" should be in position -1 of the :code stack    


  Scenario: code_container should return an :error if its arg1 can't be parsed
    Given I have pushed "bbbbbbbbbbbbb" onto the :code stack
    And I have pushed "ref g" onto the :code stack
    When I execute the Nudge instruction "code_container"
    Then stack :code should have depth 0
    Then the top :error should include "InvalidScript"


  Scenario: code_container should return an :error if its arg1 can't be parsed
    Given I have pushed "block {do int_add}" onto the :code stack
    And I have pushed "asjaksdjkadf g" onto the :code stack
    When I execute the Nudge instruction "code_container"
    Then stack :code should have depth 0
    Then the top :error should include "InvalidScript"
