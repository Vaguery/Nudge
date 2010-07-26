Feature: Float from bool
  In order to convert floats to ints in a relatively unbiased way
  As a modeler
  I want a float_from_bool that returns -1 for false and +1 for true
  
  Scenario: false gives -1.0
    Given I have pushed "false" onto the :bool stack
    When I execute the Nudge instruction "float_from_bool"
    Then something close to "-1.0" should be in position -1 of the :float stack
    And stack :bool should have depth 0
    
  
  Scenario: true gives 1.0
    Given I have pushed "true" onto the :bool stack
    When I execute the Nudge instruction "float_from_bool"
    Then something close to "1.0" should be in position -1 of the :float stack
    And stack :bool should have depth 0
  
  
  
