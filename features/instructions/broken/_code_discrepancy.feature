#encoding: utf-8
Feature: code_discrepancy instruction
  In order to build models that respond to structural differences in :code objects
  As a modeler
  I want Nudge instructions that compare and measure program structures
    
  Scenario: code_discrepancy should return 0 for two identical :code items
    Given I have pushed "block {do a ref y}" onto the :code stack
    And I have pushed "block {do a ref y}" onto the :code stack
    When I execute the Nudge instruction "code_discrepancy"
    Then "0" should be in position 0 of the :int stack
    And stack :code should have depth 0
    
    
  Scenario: code_discrepancy should count the differences in the counts of points (by blueprint)
    Given I have pushed "block {do a ref y ref y}" onto the :code stack
    And I have pushed "block {do a ref y}" onto the :code stack
    When I execute the Nudge instruction "code_discrepancy"
    Then "2" should be in position 0 of the :int stack
    And stack :code should have depth 0
    
    
  Scenario: code_discrepancy should refer to the list of points
    Given I have pushed "block {do a ref y}" onto the :code stack
    And I have pushed "block {do b ref y}" onto the :code stack
    When I execute the Nudge instruction "code_discrepancy"
    Then "2" should be in position 0 of the :int stack
    And stack :code should have depth 0
    
    
  Scenario: code_discrepancy should be maximal when two blocks are totally different
    Given I have pushed "block {do a ref x ref x}" onto the :code stack
    And I have pushed "block {do b ref y ref z}" onto the :code stack
    When I execute the Nudge instruction "code_discrepancy"
    Then "8" should be in position 0 of the :int stack
    And stack :code should have depth 0
    
    
  Scenario: code_discrepancy should be equal the number of points when the other is unparseable
    Given I have pushed "block {do a ref x ref x}" onto the :code stack
    And I have pushed "quality of mercy" onto the :code stack
    When I execute the Nudge instruction "code_discrepancy"
    Then "4" should be in position 0 of the :int stack
    And stack :code should have depth 0
    
    
  Scenario: code_discrepancy should be 0 when both are unparseable
    Given I have pushed "w00t" onto the :code stack
    And I have pushed "lulz" onto the :code stack
    When I execute the Nudge instruction "code_discrepancy"
    Then "0" should be in position 0 of the :int stack
    And stack :code should have depth 0
