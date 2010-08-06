Feature: int_yankdup instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to pull things up from down inside any given stack
    
  Scenario: positive pointer less than stack depth -> pull up a copy of item at depth N to the top
    Given I have pushed "1" onto the :int stack
    And I have pushed "2" onto the :int stack
    And I have pushed "3" onto the :int stack
    And I have pushed "4" onto the :int stack
    And I have pushed "5" onto the :int stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "int_yankdup"
    Then stack :int should have depth 6
    And the :int stack should be ["1", "2", "3", "4", "5", "3"]
    
    
  Scenario: negative pointer -> duplicate the top item
    Given I have pushed "1" onto the :int stack
    And I have pushed "2" onto the :int stack
    And I have pushed "3" onto the :int stack
    And I have pushed "4" onto the :int stack
    And I have pushed "5" onto the :int stack
    And I have pushed "-9" onto the :int stack
    When I execute the Nudge instruction "int_yankdup"
    Then stack :int should have depth 6
    And the :int stack should be ["1", "2", "3", "4", "5", "5"]
    
    
  Scenario: zero pointer -> duplicate the top item
    Given I have pushed "1" onto the :int stack
    And I have pushed "2" onto the :int stack
    And I have pushed "3" onto the :int stack
    And I have pushed "4" onto the :int stack
    And I have pushed "5" onto the :int stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "int_yankdup"
    Then stack :int should have depth 6
    And the :int stack should be ["1", "2", "3", "4", "5", "5"]
    
    
  Scenario: large positive pointer -> pull up a copy of the bottom item of the stack
    Given I have pushed "1" onto the :int stack
    And I have pushed "2" onto the :int stack
    And I have pushed "3" onto the :int stack
    And I have pushed "4" onto the :int stack
    And I have pushed "5" onto the :int stack
    And I have pushed "818819" onto the :int stack
    When I execute the Nudge instruction "int_yankdup"
    Then stack :int should have depth 6
    And the :int stack should be ["1", "2", "3", "4", "5", "1"]
    