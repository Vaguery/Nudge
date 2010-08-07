Feature: int_yank instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to pull things up from down inside any given stack
    
  Scenario: positive pointer less than stack depth -> pull up item at depth N to the top
    Given I have pushed "1" onto the :int stack
    And I have pushed "2" onto the :int stack
    And I have pushed "3" onto the :int stack
    And I have pushed "4" onto the :int stack
    And I have pushed "5" onto the :int stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "int_yank"
    Then stack :int should have depth 5
    And the :int stack should be ["1", "2", "4", "5", "3"]
    
    
  Scenario: negative pointer -> do nothing
    Given I have pushed "1" onto the :int stack
    And I have pushed "2" onto the :int stack
    And I have pushed "3" onto the :int stack
    And I have pushed "4" onto the :int stack
    And I have pushed "5" onto the :int stack
    And I have pushed "-9" onto the :int stack
    When I execute the Nudge instruction "int_yank"
    Then stack :int should have depth 5
    And the :int stack should be ["1", "2", "3", "4", "5"]
    
    
  Scenario: zero pointer -> do nothing
    Given I have pushed "1" onto the :int stack
    And I have pushed "2" onto the :int stack
    And I have pushed "3" onto the :int stack
    And I have pushed "4" onto the :int stack
    And I have pushed "5" onto the :int stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "int_yank"
    Then stack :int should have depth 5
    And the :int stack should be ["1", "2", "3", "4", "5"]
    
    
  Scenario: large positive pointer -> pull up the bottom item of the stack
    Given I have pushed "1" onto the :int stack
    And I have pushed "2" onto the :int stack
    And I have pushed "3" onto the :int stack
    And I have pushed "4" onto the :int stack
    And I have pushed "5" onto the :int stack
    And I have pushed "818819" onto the :int stack
    When I execute the Nudge instruction "int_yank"
    Then stack :int should have depth 5
    And the :int stack should be ["2", "3", "4", "5", "1"]
