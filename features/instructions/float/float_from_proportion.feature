Feature: Float from proportion
  In order to shift items from one stack to another
  As a modeler
  I want Nudge to have a float_from_proportion instruction
  
  
  Scenario: simple enough
    Given I have pushed "0.121" onto the :proportion stack
    When I execute the Nudge instruction "float_from_proportion"
    Then something close to "0.121" should be in position -1 of the :float stack
    And stack :proportion should have depth 0
    
  
  
