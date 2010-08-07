Feature: name_yankdup instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to pull things up from down inside any given stack
    
  Scenario: positive pointer less than stack depth -> pull up a copy of item at depth N to the top
    Given I have pushed "a" onto the :name stack
    And I have pushed "b" onto the :name stack
    And I have pushed "c" onto the :name stack
    And I have pushed "d" onto the :name stack
    And I have pushed "e" onto the :name stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "name_yankdup"
    Then stack :name should have depth 6
    And the :name stack should be ["a", "b", "c", "d", "e", "c"]
    
    
  Scenario: negative pointer -> duplicate the top item
    Given I have pushed "a" onto the :name stack
    And I have pushed "b" onto the :name stack
    And I have pushed "c" onto the :name stack
    And I have pushed "d" onto the :name stack
    And I have pushed "e" onto the :name stack
    And I have pushed "-92" onto the :int stack
    When I execute the Nudge instruction "name_yankdup"
    Then stack :name should have depth 6
    And the :name stack should be ["a", "b", "c", "d", "e", "e"]
    
    
  Scenario: zero pointer -> duplicate the top item
    Given I have pushed "a" onto the :name stack
    And I have pushed "b" onto the :name stack
    And I have pushed "c" onto the :name stack
    And I have pushed "d" onto the :name stack
    And I have pushed "e" onto the :name stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "name_yankdup"
    Then stack :name should have depth 6
    And the :name stack should be ["a", "b", "c", "d", "e", "e"]
    
    
  Scenario: large positive pointer -> pull up a copy of the bottom item of the stack
    Given I have pushed "a" onto the :name stack
    And I have pushed "b" onto the :name stack
    And I have pushed "c" onto the :name stack
    And I have pushed "d" onto the :name stack
    And I have pushed "e" onto the :name stack
    And I have pushed "12345" onto the :int stack
    When I execute the Nudge instruction "name_yankdup"
    Then stack :name should have depth 6
    And the :name stack should be ["a", "b", "c", "d", "e", "a"]
  