#encoding: utf-8
Feature: Code structure measurements
  In order to build models that respond to structural differences in :code objects
  As a modeler
  I want Nudge instructions that compare and measure program structures
  
  
  Scenario: code_backbone_points should return the number of points in the root of a program
    Given an interpreter with "block {do a do b}" on the :code stack
    When I execute "do code_backbone_points"
    Then a new :int with value "2" should be on top of the :int stack
    And the argument should be gone
  
  
  Scenario: code_backbone_points should not count points within backbone points
    Given an interpreter with "block {block {do a} block {do b}}" on the :code stack
    When I execute "do code_backbone_points"
    Then a new :int with value "2" should be on top of the :int stack
    And the argument should be gone
  
  
  Scenario: code_backbone_points should return 0 for an empty block
    Given an interpreter with "block {}" on the :code stack
    When I execute "do code_backbone_points"
    Then a new :int with value "0" should be on top of the :int stack
    And the argument should be gone
  
  
  Scenario: code_backbone_points should return 0 for a reference
    Given an interpreter with "ref x" on the :code stack
    When I execute "do code_backbone_points"
    Then a new :int with value "0" should be on top of the :int stack
    And the argument should be gone
  
  
  Scenario: code_backbone_points should return 0 for an instruction
    Given an interpreter with "do int_subtract" on the :code stack
    When I execute "do code_backbone_points"
    Then a new :int with value "0" should be on top of the :int stack
    And the argument should be gone
  
  
  Scenario: code_backbone_points should return 0 for a value
    Given an interpreter with "value «bool»\n«bool» false" on the :code stack
    When I execute "do code_backbone_points"
    Then a new :int with value "0" should be on top of the :int stack
    And the argument should be gone
  
  
  Scenario: code_backbone_points should return 0 for unparseable code
    Given an interpreter with "i'm a little teapot" on the :code stack
    When I execute "do code_backbone_points"
    Then a new :int with value "0" should be on top of the :int stack
    And the argument should be gone
  
  
  Scenario: code_backbone_points should return 0 for unparseable code
    Given an interpreter with "i'm a little teapot" on the :code stack
    When I execute "do code_backbone_points"
    Then a new :int with value "0" should be on top of the :int stack
    And the argument should be gone
  
  
  
  
  
  
  Scenario: code_discrepancy should return 0 for two identical :code items
    Given an interpreter with "block {do a ref y}" on the :code stack
    And  "block {do a ref y}" above that on the :code stack
    When I execute "do code_discrepancy"
    Then a new :int with value "0" should be on top of the :int stack
    And the argument should be gone
    
    
  Scenario: code_discrepancy should count the differences in the counts of points (by blueprint)
    Given an interpreter with "block {do a ref y ref y}" on the :code stack
    And  "block {do a ref y}" above that on the :code stack
    When I execute "do code_discrepancy"
    Then a new :int with value "2" should be on top of the :int stack
    And the argument should be gone
    
    
  Scenario: code_discrepancy should refer to the list of points 
    Given an interpreter with "block {do a ref y}" on the :code stack
    And  "block {do b ref y}" above that on the :code stack
    When I execute "do code_discrepancy"
    Then a new :int with value "2" should be on top of the :int stack
    And the argument should be gone
    
    
  Scenario: code_discrepancy should be maximal when two blocks are totally different 
    Given an interpreter with "block {do a ref x ref x}" on the :code stack
    And  "block {do b ref y ref z}" above that on the :code stack
    When I execute "do code_discrepancy"
    Then a new :int with value "3" should be on top of the :int stack
    And the argument should be gone
    
    
  Scenario: code_discrepancy should be equal the number of points when the other is unparseable 
    Given an interpreter with "block {do a ref x ref x}" on the :code stack
    And  "toad the wet sprocket" above that on the :code stack
    When I execute "do code_discrepancy"
    Then a new :int with value "4" should be on top of the :int stack
    And the argument should be gone
    
    
  Scenario: code_discrepancy should be 0 when both are unparseable 
    Given an interpreter with "left hand" on the :code stack
    And  "right hand" above that on the :code stack
    When I execute "do code_discrepancy"
    Then a new :int with value "0" should be on top of the :int stack
    And the argument should be gone
    
    
    
    
    
    
  Scenario: code_points should return the number of points in a block item 
    Given an interpreter with "block {do a ref x ref x}" on the :code stack
    When I execute "do code_points"
    Then a new :int with value "4" should be on top of the :int stack
    And the argument should be gone
  
  
  Scenario: code_points should return the number of points in a reference item 
    Given an interpreter with "ref g" on the :code stack
    When I execute "do code_points"
    Then a new :int with value "1" should be on top of the :int stack
    And the argument should be gone
    
    
  Scenario: code_points should return the number of points in an instruction item 
    Given an interpreter with "do bool_and" on the :code stack
    When I execute "do code_points"
    Then a new :int with value "1" should be on top of the :int stack
    And the argument should be gone
    
    
  Scenario: code_points should return the number of points in a value item 
    Given an interpreter with "value «float»\n«float» 1.1" on the :code stack
    When I execute "do code_points"
    Then a new :int with value "1" should be on top of the :int stack
    And the argument should be gone
    
    
  Scenario: code_points should return 0 for unparseable code 
    Given an interpreter with "you're a mean one mister grinch" on the :code stack
    When I execute "do code_points"
    Then a new :int with value "0" should be on top of the :int stack
    And the argument should be gone
