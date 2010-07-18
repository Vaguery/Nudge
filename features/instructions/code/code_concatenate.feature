Feature: code_concatenate instruction
  In order to combine multiple code points into one block
  As a lumper
  I want Nudge a code_concatenate instruction
  
  
  Scenario: code_concatenate should concatenate two blocks
    Given I have pushed "block {ref x ref y}" onto the :code stack
    And I have pushed "block {do a do b}" onto the :code stack
    When I execute the Nudge instruction "code_concatenate"
    Then "block {ref x ref y do a do b}" should be in position -1 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_concatenate should append a non-block item to a block
    Given I have pushed "block {ref x ref x}" onto the :code stack
    And I have pushed "value «int»\n«int» 8" onto the :code stack
    When I execute the Nudge instruction "code_concatenate"
    Then "block {ref x ref x value «int»} \n«int» 8" should be in position -1 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_concatenate should create a new block when the first argument is not one
    Given I have pushed "do a" onto the :code stack
    And I have pushed "block {ref x}" onto the :code stack
    When I execute the Nudge instruction "code_concatenate"
    Then "block {do a ref x}" should be in position -1 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_concatenate should create a new block when neither is one
    Given I have pushed "do a" onto the :code stack
    And I have pushed "ref b" onto the :code stack
    When I execute the Nudge instruction "code_concatenate"
    Then "block { do a ref b }" should be in position -1 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_concatenate should work correctly with footnotes
    Given I have pushed "value «int»\n«int» 12" onto the :code stack
    And I have pushed "value «float»\n«float» 1.1" onto the :code stack
    When I execute the Nudge instruction "code_concatenate"
    Then "block { value «int» value «float» }\n«int»12\n«float»1.1" should be in position 0 of the :code stack
