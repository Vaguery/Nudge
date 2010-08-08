#encoding: utf-8
Feature: Code classification
  In order to build control structures and make decisions based on script structure
  As a modeler
  I want a code_in_backbone? instruction that tells me if a :code item appears in the backbone of another
  
    
  Scenario: code_in_backbone? should be true if the 2nd argument is in the backbone of the first
    Given I have pushed "block {do x}" onto the :code stack
    And I have pushed "do x" onto the :code stack
    When I execute the Nudge instruction "code_in_backbone?"
    Then "true" should be in position -1 of the :bool stack
    And stack :code should have depth 0
    
    
  Scenario: should be false if the 2nd argument is the same as the first
    Given I have pushed "block {do x}" onto the :code stack
    And I have pushed "block { do x }" onto the :code stack
    When I execute the Nudge instruction "code_in_backbone?"
    Then "false" should be in position -1 of the :bool stack
    And stack :code should have depth 0
    
    
  Scenario: should be false if the 2nd argument is inside the 1st but not in the root
    Given I have pushed "block {block {do x}}" onto the :code stack
    And I have pushed "do x" onto the :code stack
    When I execute the Nudge instruction "code_in_backbone?"
    Then "false" should be in position -1 of the :bool stack
    And stack :code should have depth 0
    
    
  Scenario: should be false if the 2nd argument is not inside the 1st
    Given I have pushed "block {do x}" onto the :code stack
    And I have pushed "do y" onto the :code stack
    When I execute the Nudge instruction "code_in_backbone?"
    Then "false" should be in position -1 of the :bool stack
    And stack :code should have depth 0
    
  
  Scenario: should produce an :error if the 1st arg can't be parsed
    Given I have pushed "hbsfjkbakjshbkjasd" onto the :code stack
    And I have pushed "do y" onto the :code stack
    When I execute the Nudge instruction "code_in_backbone?"
    Then the top :error should include "InvalidScript"
    And stack :bool should have depth 0
    
    
  Scenario: should produce an :error if the 2nd arg can't be parsed
    Given I have pushed "block {do k}" onto the :code stack
    And I have pushed "kaslknaksd" onto the :code stack
    When I execute the Nudge instruction "code_in_backbone?"
    Then the top :error should include "InvalidScript"
    And stack :bool should have depth 0
    
    
  Scenario: should be false if the 1st arg isn't a block (different from Push3 CODE.MEMBER)
    Given I have pushed "do x" onto the :code stack
    And I have pushed "do x" onto the :code stack
    When I execute the Nudge instruction "code_in_backbone?"
    Then "false" should be in position -1 of the :bool stack
    And stack :code should have depth 0
    
    
  Scenario: it should work with complicated footnotes
    Given I have pushed "block {value «code» ref a value «code»}\n«int» 9\n«code» value «int»\n«code» ref h" onto the :code stack
    And I have pushed "value «code»\n«code» value «int»\n«int» 9" onto the :code stack
    When I execute the Nudge instruction "code_in_backbone?"
    Then "true" should be in position -1 of the :bool stack
    And stack :code should have depth 0
  
  
  