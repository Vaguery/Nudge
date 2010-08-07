Feature: int log e
  In order to work with large integer numbers
  As a modeler
  I want a int_log_e instruction

  
  Scenario: big positive values are fine
    Given I have pushed "1000" onto the :int stack
    When I execute the Nudge instruction "int_log_e"
    Then "6" should be in position -1 of the :int stack
    And stack :error should have depth 0

  Scenario: small positive values are fine
    Given I have pushed "1" onto the :int stack
    When I execute the Nudge instruction "int_log_e"
    Then "0" should be in position -1 of the :int stack
    And stack :error should have depth 0
    
  Scenario: 1 -> 0
    Given I have pushed "1" onto the :int stack
    When I execute the Nudge instruction "int_log_e"
    Then "0" should be in position -1 of the :int stack
    And stack :error should have depth 0
    
  Scenario: 0 produces an error
    Given I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "int_log_e"
    Then "NaN: result of int_log_e was not an int" should be in position -1 of the :error stack
  
  Scenario: negative values should produce an :error
    Given I have pushed "-12" onto the :int stack
    When I execute the Nudge instruction "int_log_e"
    Then "NaN: result of int_log_e was not an int" should be in position -1 of the :error stack
    
  Scenario: Infinite results should produce an :error
    Given I have pushed "1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" onto the :int stack
    When I execute the Nudge instruction "int_log_e"
    Then "NaN: result of int_log_e was not an int" should be in position -1 of the :error stack
    