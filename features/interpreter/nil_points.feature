Feature: NilPoints
  In order to intelligently handle items that don't parse
  As a modeler
  I want the Nudge parser to return a NilPoint if it cannot parse code
  
  
  Scenario: NilPoint results from parsing an empty script
    Given the blueprint ""
    When I parse that blueprint
    Then the result should be a NilPoint
    And its script should be ""
  
  
  Scenario: NilPoint results from parsing a script that only has footnotes
    Given the blueprint "\n«int» 8"
    When I parse that blueprint
    Then the result should be a NilPoint
    And its script should be "\n«int» 8"
  
  
  Scenario: NilPoint results from parsing untokenized code
    Given the blueprint "777a"
    When I parse that blueprint
    Then the result should be a NilPoint
    And its script should be "777a"
  
  
  Scenario: NilPoint results even from tokenized but unparseable code
    Given the blueprint "foo_bar"
    When I parse that blueprint
    Then the result should be a NilPoint
    And its script should be "foo_bar"
  
  
  Scenario: NilPoint should have a #points attribute of 0
    Given the blueprint "foo_bar"
    When I parse that blueprint
    Then the number of points should be 0
    
    
  
  
  
  

  
