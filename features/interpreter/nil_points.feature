Feature: NilPoints
  In order to intelligently handle items that don't parse
  As a modeler
  I want the Nudge parser to return a NilPoint if it cannot parse code
  
  Scenario: NilPoint results from parsing unrecognized code
    Given the blueprint "foo bar baz"
    When I parse that blueprint
    Then the result should be a NilPoint
  
  
  Scenario: NilPoint should have a #points attribute of 0
    Given a NilPoint
    When I count the points
    Then the result should be 0
    
    
  
  
  
  

  
