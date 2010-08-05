Feature: int from bool
  In order to convert ints to ints in a relatively unbiased way
  As a modeler
  I want an int_from_bool that returns -1 for false and +1 for true
  
  Scenario: false gives -1
    Given I have pushed "false" onto the :bool stack
    When I execute the Nudge instruction "int_from_bool"
    Then "-1" should be in position -1 of the :int stack
    And stack :bool should have depth 0
    
  
  Scenario: true gives 1
    Given I have pushed "true" onto the :bool stack
    When I execute the Nudge instruction "int_from_bool"
    Then "1" should be in position -1 of the :int stack
    And stack :bool should have depth 0
  
  
  
