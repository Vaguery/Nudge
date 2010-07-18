Feature: NilPoints
  In order to intelligently handle items that don't parse
  As a modeler
  I want the Nudge parser to return a NilPoint if it cannot parse code
  
  Scenario: NilPoint results from parsing unrecognized code
    Given the blueprint "foo bar baz"
    When I parse that blueprint
    Then the result should be a NilPoint
    And its script sound be "foo bar baz"
  
  
  Scenario: NilPoint results even from partially-parsed code
    Given the blueprint "block {do int_add ggrrrrrzzz}"
    When I parse that blueprint
    Then the result should be a NilPoint
    And its script sound be "block {do int_add ggrrrrrzzz}"
  
  
  Scenario: NilPoint should have a #points attribute of 0
    Given a NilPoint
    When I count the points
    Then the result should be 0
    
    
  
  
  
  

  
