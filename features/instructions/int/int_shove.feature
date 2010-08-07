Feature: int_shove instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to push things down into any given stack
    
  Scenario: positive pointer less than stack depth -> push the top item down N steps
    Given I have pushed "11" onto the :int stack
    And I have pushed "22" onto the :int stack
    And I have pushed "33" onto the :int stack
    And I have pushed "44" onto the :int stack
    And I have pushed "55" onto the :int stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "int_shove"
    Then stack :int should have depth 5
    And the :int stack should be ["11", "22", "55", "33", "44"]
    
    
  Scenario: negative pointer -> do nothing
    Given I have pushed "11" onto the :int stack
    And I have pushed "22" onto the :int stack
    And I have pushed "33" onto the :int stack
    And I have pushed "44" onto the :int stack
    And I have pushed "55" onto the :int stack
    And I have pushed "-2" onto the :int stack
    When I execute the Nudge instruction "int_shove"
    Then stack :int should have depth 5
    And the :int stack should be ["11", "22", "33", "44", "55"]
    
    
  Scenario: zero pointer -> do nothing
    Given I have pushed "11" onto the :int stack
    And I have pushed "22" onto the :int stack
    And I have pushed "33" onto the :int stack
    And I have pushed "44" onto the :int stack
    And I have pushed "55" onto the :int stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "int_shove"
    Then stack :int should have depth 5
    And the :int stack should be ["11", "22", "33", "44", "55"]
    
    
  Scenario: large positive pointer -> push the top item to the bottom of the stack
    Given I have pushed "11" onto the :int stack
    And I have pushed "22" onto the :int stack
    And I have pushed "33" onto the :int stack
    And I have pushed "44" onto the :int stack
    And I have pushed "55" onto the :int stack
    And I have pushed "9900002" onto the :int stack
    When I execute the Nudge instruction "int_shove"
    Then stack :int should have depth 5
    And the :int stack should be ["55", "11", "22", "33", "44"]
