Feature: name_yank instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to pull things up from down inside any given stack
    
  Scenario: positive pointer less than stack depth -> pull up item at depth N to the top
    Given I have pushed "a" onto the :name stack
    And I have pushed "b" onto the :name stack
    And I have pushed "c" onto the :name stack
    And I have pushed "d" onto the :name stack
    And I have pushed "e" onto the :name stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "name_yank"
    Then stack :name should have depth 5
    And the :name stack should be ["a", "b", "d", "e", "c"]
    
    
  Scenario: negative pointer -> do nothing
    Given I have pushed "a" onto the :name stack
    And I have pushed "b" onto the :name stack
    And I have pushed "c" onto the :name stack
    And I have pushed "d" onto the :name stack
    And I have pushed "e" onto the :name stack
    And I have pushed "-92" onto the :int stack
    When I execute the Nudge instruction "name_yank"
    Then stack :name should have depth 5
    And the :name stack should be ["a", "b", "c", "d", "e"]
    
    
  Scenario: zero pointer -> do nothing
    Given I have pushed "a" onto the :name stack
    And I have pushed "b" onto the :name stack
    And I have pushed "c" onto the :name stack
    And I have pushed "d" onto the :name stack
    And I have pushed "e" onto the :name stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "name_yank"
    Then stack :name should have depth 5
    And the :name stack should be ["a", "b", "c", "d", "e"]
    
    
  Scenario: large positive pointer -> pull up the bottom item of the stack
    Given I have pushed "a" onto the :name stack
    And I have pushed "b" onto the :name stack
    And I have pushed "c" onto the :name stack
    And I have pushed "d" onto the :name stack
    And I have pushed "e" onto the :name stack
    And I have pushed "12345" onto the :int stack
    When I execute the Nudge instruction "name_yank"
    Then stack :name should have depth 5
    And the :name stack should be ["b", "c", "d", "e", "a"]
