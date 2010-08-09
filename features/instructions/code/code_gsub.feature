Feature: Code gsub
  In order to manipulate :code trees in complex ways
  As a modeler
  I want code_gsub to replace occurrences of one subtree with another

    
  Scenario: it should return arg1 unchanged if arg2 isn't found
    Given I have pushed "block {ref a ref b}" onto the :code stack
    And I have pushed "do int_add" onto the :code stack
    And I have pushed "ref k" onto the :code stack
    When I execute the Nudge instruction "code_gsub"
    Then "block {ref a ref b}" should be in position -1 of the :code stack
    And stack :code should have depth 1
    
    
  Scenario: code_gsub should replace all subtrees in arg1 matching arg2 with arg3
    Given I have pushed "block {ref x ref y block {ref x}}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    And I have pushed "do a" onto the :code stack
    When I execute the Nudge instruction "code_gsub"
    Then "block { do a ref y block { do a } }" should be in position -1 of the :code stack
    And stack :code should have depth 1
    
    
  Scenario: it should work even when recognizing complicated trees as targets
    Given I have pushed "block { block {value «code» ref h}}\n«code»value «int»\n«int»12" onto the :code stack
    And I have pushed "value «code»\n«code» value «int»\n«int» 12" onto the :code stack
    And I have pushed "ref REPLACED" onto the :code stack
    When I execute the Nudge instruction "code_gsub"
    Then "block {block {ref REPLACED ref h}}" should be in position -1 of the :code stack
    And stack :code should have depth 1
    
    
  Scenario: code_gsub should traverse subtrees in arg1
    Given I have pushed "block {ref x block {ref y block {ref x}}}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    And I have pushed "do a" onto the :code stack
    When I execute the Nudge instruction "code_gsub"
    Then "block { do a block { ref y block { do a } } }" should be in position -1 of the :code stack
    And stack :code should have depth 1
    
    
  Scenario: code_gsub should not search code in footnotes
    Given I have pushed "block {ref x value «code»} \n«code» ref x" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    And I have pushed "do a" onto the :code stack
    When I execute the Nudge instruction "code_gsub"
    Then "block { do a value «code» }\n«code» ref x" should be in position -1 of the :code stack
    And stack :code should have depth 1
    
    
  Scenario: code_gsub should replace footnotes as appropriate
    Given I have pushed "block {value «code» value «int»} \n«code» ref x \n«int» 9" onto the :code stack
    And I have pushed "value «int» \n«int» 9" onto the :code stack
    And I have pushed "do a" onto the :code stack
    When I execute the Nudge instruction "code_gsub"
    Then "block { value «code» do a }\n«code»ref x" should be in position -1 of the :code stack
    And stack :code should have depth 1
    
    
  Scenario: code_gsub should return an :error if arg1 is unparseable
    Given I have pushed "rooty toot toot" onto the :code stack
    And I have pushed "value «int» \n«int» 9" onto the :code stack
    And I have pushed "do a" onto the :code stack
    When I execute the Nudge instruction "code_gsub"
    Then stack :code should have depth 0
    Then the top :error should include "InvalidScript"


  Scenario: code_gsub should return an :error if arg1 is unparseable
    Given I have pushed "do int_add" onto the :code stack
    And I have pushed "88a" onto the :code stack
    And I have pushed "do a" onto the :code stack
    When I execute the Nudge instruction "code_gsub"
    Then stack :code should have depth 0
    Then the top :error should include "InvalidScript"


  Scenario: code_gsub should return an :error if arg1 is unparseable
    Given I have pushed "ref t" onto the :code stack
    And I have pushed "value «int» \n«int» 9" onto the :code stack
    And I have pushed "funtastic" onto the :code stack
    When I execute the Nudge instruction "code_gsub"
    Then stack :code should have depth 0
    Then the top :error should include "InvalidScript"
  