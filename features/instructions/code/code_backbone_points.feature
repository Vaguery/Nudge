#encoding: utf-8
Feature: code_backbone_points instruction
  In order to build models that respond to structural differences in :code objects
  As a modeler
  I want Nudge instructions that compare and measure program structures
  
  
  Scenario: code_backbone_points should return the number of points in the root of a program
    Given I have pushed "block {do a do b}" onto the :code stack
    When I execute the Nudge instruction "code_backbone_points"
    Then "2" should be in position 0 of the :int stack
    And stack :code should have depth 0
    
    
  Scenario: code_backbone_points should not count points within backbone points
    Given I have pushed "block {block {do a} block {do b}}" onto the :code stack
    When I execute the Nudge instruction "code_backbone_points"
    Then "2" should be in position 0 of the :int stack
    And stack :code should have depth 0
  
  
  Scenario: code_backbone_points should return 0 for an empty block
    Given I have pushed "block {}" onto the :code stack
    When I execute the Nudge instruction "code_backbone_points"
    Then "0" should be in position 0 of the :int stack
    And stack :code should have depth 0
  
  
  Scenario: code_backbone_points should return 0 for a reference
    Given I have pushed "ref x" onto the :code stack
    When I execute the Nudge instruction "code_backbone_points"
    Then "0" should be in position 0 of the :int stack
    And stack :code should have depth 0
  
  
  Scenario: code_backbone_points should return 0 for an instruction
    Given I have pushed "do int_subtract" onto the :code stack
    When I execute the Nudge instruction "code_backbone_points"
    Then "0" should be in position 0 of the :int stack
    And stack :code should have depth 0
  
  
  Scenario: code_backbone_points should return 0 for a value
    Given I have pushed "value «bool»\n«bool» false" onto the :code stack
    When I execute the Nudge instruction "code_backbone_points"
    Then "0" should be in position 0 of the :int stack
    And stack :code should have depth 0
  
  
  Scenario: code_backbone_points should return 0 for unparseable code
    Given I have pushed "no business like show business" onto the :code stack
    When I execute the Nudge instruction "code_backbone_points"
    Then "0" should be in position 0 of the :int stack
    And stack :code should have depth 0
  
