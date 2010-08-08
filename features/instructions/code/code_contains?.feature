#encoding: utf-8
Feature: code_contains? instruction
  In order to build models that respond to structural differences in :code objects
  As a modeler
  I want Nudge instructions that compare and measure program structures
  
  
  Scenario: code_contains? should return true if arg1 contains arg2 as a point anywhere
    Given I have pushed "block {ref x do a}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    When I execute the Nudge instruction "code_contains?"
    Then "true" should be in position 0 of the :bool stack
    And stack :code should have depth 0
  
  
  Scenario: code_contains? should return false if arg1 doesn't contain arg2 as a point anywhere
    Given I have pushed "block {ref x do a}" onto the :code stack
    And I have pushed "ref y" onto the :code stack
    When I execute the Nudge instruction "code_contains?"
    Then "false" should be in position 0 of the :bool stack
    And stack :code should have depth 0
  
  
  Scenario: code_contains? should return true if arg1 == arg2 
    Given I have pushed "block {ref x do a}" onto the :code stack
    And I have pushed "block {ref x do a}" onto the :code stack
    When I execute the Nudge instruction "code_contains?"
    Then "true" should be in position 0 of the :bool stack
    And stack :code should have depth 0
    
    
  Scenario: works with value points
    Given I have pushed "block {value «int» do a} \n«int» 9" onto the :code stack
    And I have pushed "value «int» \n«int» 9" onto the :code stack
    When I execute the Nudge instruction "code_contains?"
    Then "true" should be in position 0 of the :bool stack
    And stack :code should have depth 0
    
    
  Scenario: code_contains? should return an :error if its arg1 can't be parsed
    Given I have pushed "askjdnkajsndkas" onto the :code stack
    And I have pushed "block {}" onto the :code stack
    When I execute the Nudge instruction "code_contains?"
    Then stack :code should have depth 0
    And the top :error should include "InvalidScript"


  Scenario: code_contains? should return an :error if its arg2 can't be parsed
    Given I have pushed "ref h" onto the :code stack
    And I have pushed "jsjnkjnsfksfd" onto the :code stack
    When I execute the Nudge instruction "code_contains?"
    Then stack :code should have depth 0
    And the top :error should include "InvalidScript"
    