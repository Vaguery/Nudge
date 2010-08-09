#encoding: utf-8
Feature: code_discrepancy instruction
  In order to build models that respond to structural differences in :code objects
  As a modeler
  I want Nudge instructions that compare and measure program structures
    
  Scenario: code_discrepancy should return 0 for two identical :code items
    Given I have pushed "block {do a ref y}" onto the :code stack
    And I have pushed "block {do a ref y}" onto the :code stack
    When I execute the Nudge instruction "code_discrepancy"
    Then "0" should be in position -1 of the :int stack
    And stack :code should have depth 0
    
    
  Scenario: if the code differs in all details, it should count the total number of points in both
    Given I have pushed "block {ref a ref b block {ref c}}" onto the :code stack
    And I have pushed "block {ref d block {ref e ref f block {ref g}}}" onto the :code stack
    When I execute the Nudge instruction "code_discrepancy"
    Then "12" should be in position -1 of the :int stack
    And stack :code should have depth 0
    
    
  Scenario: if code contains duplicates of one or more points, they are collected first
    Given I have pushed "block {ref a ref a block {ref a}}" onto the :code stack
    And I have pushed "block {ref a block {ref e ref f block {ref e}}}" onto the :code stack
    When I execute the Nudge instruction "code_discrepancy"
    Then "10" should be in position -1 of the :int stack
    And stack :code should have depth 0
    
    
  Scenario: code_discrepancy should count the differences in the counts of points (by blueprint)
    Given I have pushed "block {do a ref y ref y}" onto the :code stack
    And I have pushed "block {do a ref y}" onto the :code stack
    When I execute the Nudge instruction "code_discrepancy"
    Then "3" should be in position 0 of the :int stack
    And stack :code should have depth 0
    
    
  Scenario: code_discrepancy should count each arg as different from the other, not just one direction
    Given I have pushed "block {do a ref y}" onto the :code stack
    And I have pushed "block {do b ref y}" onto the :code stack
    When I execute the Nudge instruction "code_discrepancy"
    Then "4" should be in position 0 of the :int stack
    And stack :code should have depth 0
    
    
  Scenario: code_discrepancy should be maximal when two blocks are totally different
    Given I have pushed "block {do a ref x ref x}" onto the :code stack
    And I have pushed "block {do b ref y ref z}" onto the :code stack
    When I execute the Nudge instruction "code_discrepancy"
    Then "8" should be in position 0 of the :int stack
    And stack :code should have depth 0
    
    
  Scenario: code_discrepancy produce an :error when the first argument is unparseable
    Given I have pushed "block {do a ref x ref x}" onto the :code stack
    And I have pushed "quality of mercy" onto the :code stack
    When I execute the Nudge instruction "code_discrepancy"
    Then the top :error should include "InvalidScript"
    And stack :code should have depth 0
    
    
  Scenario: code_discrepancy produce an :error when the second argument is unparseable
    Given I have pushed "do int_add" onto the :code stack
    And I have pushed "lulz" onto the :code stack
    When I execute the Nudge instruction "code_discrepancy"
    Then the top :error should include "InvalidScript"
    And stack :code should have depth 0
