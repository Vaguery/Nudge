Feature: bool_shove instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to push things down into any given stack
    
  Scenario: positive pointer less than stack depth -> push the top item down N steps
    Given I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "false" onto the :bool stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "bool_shove"
    Then stack :bool should have depth 5
    And the :bool stack should be ["true", "true", "false", "true", "true"]
    
    
  Scenario: negative pointer -> do nothing
    Given I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "false" onto the :bool stack
    And I have pushed "-2" onto the :int stack
    When I execute the Nudge instruction "bool_shove"
    Then stack :bool should have depth 5
    And the :bool stack should be ["true", "true", "true", "true", "false"]
    
    
  Scenario: zero pointer -> do nothing
    Given I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "false" onto the :bool stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "bool_shove"
    Then stack :bool should have depth 5
    And the :bool stack should be ["true", "true", "true", "true", "false"]
    
    
  Scenario: large positive pointer -> push the top item to the bottom of the stack
    Given I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "false" onto the :bool stack
    And I have pushed "234567" onto the :int stack
    When I execute the Nudge instruction "bool_shove"
    Then stack :bool should have depth 5
    And the :bool stack should be ["false", "true", "true", "true", "true"]
