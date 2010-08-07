#encoding: utf-8
Feature: code_parses? instruction
  In order to manage (unlikely?) situations where bad strings might be pushed to stacks
  As a modeler
  I want a code_parses? that returns a boolean
    
    
  Scenario: code_parses? should be true if the :code can be parsed 
    Given I have pushed "block {do x block {do y}}" onto the :code stack
    When I execute the Nudge instruction "code_parses?"
    Then "true" should be in position 0 of the :bool stack
    And stack :code should have depth 0
  
  
  Scenario: code_parses? should be false if the :code cannot be parsed 
    Given I have pushed "block {do x block {do" onto the :code stack
    When I execute the Nudge instruction "code_parses?"
    Then "false" should be in position 0 of the :bool stack
    And stack :code should have depth 0
    
    
  Scenario: code_parses? should be false if the :code is an empty string 
    Given I have pushed "" onto the :code stack
    When I execute the Nudge instruction "code_parses?"
    Then "false" should be in position 0 of the :bool stack
    And stack :code should have depth 0
  