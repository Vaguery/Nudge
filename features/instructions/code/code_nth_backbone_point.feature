Feature: code_nth_backbone_point instruction
  In order to manipulate code objects
  As a modeler
  I want code_nth_backbone_point to extract a particular point from a code block's backbone
    
    
  Scenario: code_nth_backbone_point should return the nth backbone element (0-based) of a :code item
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "code_nth_backbone_point"
    Then stack :int should have depth 0
    And stack :code should have depth 1
    And "do a" should be in position -1 of the :code stack
    
    
  Scenario: code_nth_backbone_point should take n modulo the number of items in the backbone
    Given I have pushed "block {do a do b block {do c}}" onto the :code stack
    And I have pushed "5" onto the :int stack
    When I execute the Nudge instruction "code_nth_backbone_point"
    Then stack :int should have depth 0
    And "block {do c}" should be in position -1 of the :code stack
      
      
  Scenario: code_nth_backbone_point should work with negative pointers, via modulo
    Given I have pushed "block {do a do b block {do c}}" onto the :code stack
    And I have pushed "-1" onto the :int stack
    When I execute the Nudge instruction "code_nth_backbone_point"
    Then stack :int should have depth 0
    And "block {do c}" should be in position -1 of the :code stack
    
    
  Scenario: code_nth_backbone_point should not affect a non-block argument
    Given I have pushed "ref g" onto the :code stack
    And I have pushed "1" onto the :int stack
    When I execute the Nudge instruction "code_nth_backbone_point"
    Then stack :int should have depth 0
    And "ref g" should be in position -1 of the :code stack
    
    
  Scenario: code_nth_backbone_point should create an error if an empty block is the arg
    Given I have pushed "jnsdkfjnskskjfdn ksjfnd" onto the :code stack
    And I have pushed "1" onto the :int stack
    When I execute the Nudge instruction "code_nth_backbone_point"
    Then stack :int should have depth 0
    And the top :error should include "InvalidScript"
    
    
  Scenario: code_nth_backbone_point should create an error if an empty block is the arg
    Given I have pushed "block {}" onto the :code stack
    And I have pushed "1" onto the :int stack
    When I execute the Nudge instruction "code_nth_backbone_point"
    Then stack :int should have depth 0
    And the top :error should include "InvalidIndex"
    