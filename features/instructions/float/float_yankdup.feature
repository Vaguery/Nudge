Feature: float_yankdup instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to pull things up from down inside any given stack
    
  Scenario: positive pointer less than stack depth -> pull up a copy of item at depth N to the top
    Given I have pushed "1.1" onto the :float stack
    And I have pushed "2.2" onto the :float stack
    And I have pushed "3.3" onto the :float stack
    And I have pushed "4.4" onto the :float stack
    And I have pushed "5.5" onto the :float stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "float_yankdup"
    Then stack :float should have depth 6
    And the :float stack should be ["1.1", "2.2", "3.3", "4.4", "5.5", "3.3"]
    
    
  Scenario: negative pointer -> duplicate the top item
    Given I have pushed "1.1" onto the :float stack
    And I have pushed "2.2" onto the :float stack
    And I have pushed "3.3" onto the :float stack
    And I have pushed "4.4" onto the :float stack
    And I have pushed "5.5" onto the :float stack
    And I have pushed "-2" onto the :int stack
    When I execute the Nudge instruction "float_yankdup"
    Then stack :float should have depth 6
    And the :float stack should be ["1.1", "2.2", "3.3", "4.4", "5.5", "5.5"]
    
    
  Scenario: zero pointer -> duplicate the top item
    Given I have pushed "1.1" onto the :float stack
    And I have pushed "2.2" onto the :float stack
    And I have pushed "3.3" onto the :float stack
    And I have pushed "4.4" onto the :float stack
    And I have pushed "5.5" onto the :float stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "float_yankdup"
    Then stack :float should have depth 6
    And the :float stack should be ["1.1", "2.2", "3.3", "4.4", "5.5", "5.5"]
    
    
  Scenario: large positive pointer -> pull up a copy of the bottom item of the stack
    Given I have pushed "1.1" onto the :float stack
    And I have pushed "2.2" onto the :float stack
    And I have pushed "3.3" onto the :float stack
    And I have pushed "4.4" onto the :float stack
    And I have pushed "5.5" onto the :float stack
    And I have pushed "8877665544" onto the :int stack
    When I execute the Nudge instruction "float_yankdup"
    Then stack :float should have depth 6
    And the :float stack should be ["1.1", "2.2", "3.3", "4.4", "5.5", "1.1"]
    
  