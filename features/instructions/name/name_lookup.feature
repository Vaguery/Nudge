Feature: Name lookup
  In order to actually look up values stored in variables
  As a modeler
  I want to be able to access the value bound to a name on the :name stack

  
  Scenario: it's a bound name 
    Given I have bound "x" to an :int with value "88"
    And I have pushed "x" onto the :name stack
    When I execute the Nudge instruction "name_lookup"
    Then "88" should be in position -1 of the :int stack
    
  Scenario: it's not a bound name
    Given I have pushed "x" onto the :name stack
    When I execute the Nudge instruction "name_lookup"
    Then stack :name should have depth 0
    And "UnboundName" should be in position -1 of the :error stack
  
  
  


