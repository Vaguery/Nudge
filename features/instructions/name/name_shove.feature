Feature: name_shove instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to push things down into any given stack
    
  Scenario: positive pointer less than stack depth -> push the top item down N steps
    Given I have pushed "a" onto the :name stack
    And I have pushed "b" onto the :name stack
    And I have pushed "c" onto the :name stack
    And I have pushed "d" onto the :name stack
    And I have pushed "e" onto the :name stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "name_shove"
    Then stack :name should have depth 5
    And the :name stack should be ["a", "b", "e", "c", "d"]
    
    
  Scenario: negative pointer -> do nothing
    Given I have pushed "a" onto the :name stack
    And I have pushed "b" onto the :name stack
    And I have pushed "c" onto the :name stack
    And I have pushed "d" onto the :name stack
    And I have pushed "e" onto the :name stack
    And I have pushed "-2" onto the :int stack
    When I execute the Nudge instruction "name_shove"
    Then stack :name should have depth 5
    And the :name stack should be ["a", "b", "c", "d", "e"]
    
    
  Scenario: zero pointer -> do nothing
    Given I have pushed "a" onto the :name stack
    And I have pushed "b" onto the :name stack
    And I have pushed "c" onto the :name stack
    And I have pushed "d" onto the :name stack
    And I have pushed "e" onto the :name stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "name_shove"
    Then stack :name should have depth 5
    And the :name stack should be ["a", "b", "c", "d", "e"]
    
    
  Scenario: large positive pointer -> push the top item to the bottom of the stack
    Given I have pushed "a" onto the :name stack
    And I have pushed "b" onto the :name stack
    And I have pushed "c" onto the :name stack
    And I have pushed "d" onto the :name stack
    And I have pushed "e" onto the :name stack
    And I have pushed "9900002" onto the :int stack
    When I execute the Nudge instruction "name_shove"
    Then stack :name should have depth 5
    And the :name stack should be ["e", "a", "b", "c", "d"]
