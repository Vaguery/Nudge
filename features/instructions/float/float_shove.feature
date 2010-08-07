Feature: float_shove instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to push things down into any given stack
    
  Scenario: positive pointer less than stack depth -> push the top item down N steps
    Given I have pushed "1.1" onto the :float stack
    And I have pushed "2.2" onto the :float stack
    And I have pushed "3.3" onto the :float stack
    And I have pushed "4.4" onto the :float stack
    And I have pushed "5.5" onto the :float stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "float_shove"
    Then stack :float should have depth 5
    And the :float stack should be ["1.1", "2.2", "5.5", "3.3", "4.4"]
    
    
  Scenario: negative pointer -> do nothing
    Given I have pushed "1.1" onto the :float stack
    And I have pushed "2.2" onto the :float stack
    And I have pushed "3.3" onto the :float stack
    And I have pushed "4.4" onto the :float stack
    And I have pushed "5.5" onto the :float stack
    And I have pushed "-2" onto the :int stack
    When I execute the Nudge instruction "float_shove"
    Then stack :float should have depth 5
    And the :float stack should be ["1.1", "2.2", "3.3", "4.4", "5.5"]
    
    
  Scenario: zero pointer -> do nothing
    Given I have pushed "1.1" onto the :float stack
    And I have pushed "2.2" onto the :float stack
    And I have pushed "3.3" onto the :float stack
    And I have pushed "4.4" onto the :float stack
    And I have pushed "5.5" onto the :float stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "float_shove"
    Then stack :float should have depth 5
    And the :float stack should be ["1.1", "2.2", "3.3", "4.4", "5.5"]
    
    
  Scenario: large positive pointer -> push the top item to the bottom of the stack
    Given I have pushed "1.1" onto the :float stack
    And I have pushed "2.2" onto the :float stack
    And I have pushed "3.3" onto the :float stack
    And I have pushed "4.4" onto the :float stack
    And I have pushed "5.5" onto the :float stack
    And I have pushed "9900002" onto the :int stack
    When I execute the Nudge instruction "float_shove"
    Then stack :float should have depth 5
    And the :float stack should be ["5.5", "1.1", "2.2", "3.3", "4.4"]
