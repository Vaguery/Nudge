Feature: Float log e
  In order to work with large floating-point numbers
  As a modeler
  I want a float_log_e instruction

  
  Scenario: big positive values are fine
    Given I have pushed "1000.0" onto the :float stack
    When I execute the Nudge instruction "float_log_e"
    Then something close to "6.90775527" should be in position -1 of the :float stack
    And stack :error should have depth 0

  Scenario: small positive values are fine
    Given I have pushed "0.3" onto the :float stack
    When I execute the Nudge instruction "float_log_e"
    Then something close to "-1.2039728" should be in position -1 of the :float stack
    And stack :error should have depth 0
    
  Scenario: 1.0 -> 0.0
    Given I have pushed "1.0" onto the :float stack
    When I execute the Nudge instruction "float_log_e"
    Then something close to "0.0" should be in position -1 of the :float stack
    And stack :error should have depth 0
    
    
  Scenario: 0.0 should produce an :error
    Given I have pushed "0.0" onto the :float stack
    When I execute the Nudge instruction "float_log_e"
    Then "NaN: result of log_e was not a float" should be in position -1 of the :error stack
  
  
  Scenario: negative values should produce an :error
    Given I have pushed "-12.1" onto the :float stack
    When I execute the Nudge instruction "float_log_e"
    Then "NaN: result of log_e was not a float" should be in position -1 of the :error stack
