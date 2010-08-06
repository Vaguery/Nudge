Feature: proportion_yankdup instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to pull things up from down inside any given stack
    
  Scenario: positive pointer less than stack depth -> pull up a copy of item at depth N to the top
    Given I have pushed "0.1" onto the :proportion stack
    And I have pushed "0.2" onto the :proportion stack
    And I have pushed "0.3" onto the :proportion stack
    And I have pushed "0.4" onto the :proportion stack
    And I have pushed "0.5" onto the :proportion stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "proportion_yankdup"
    Then stack :proportion should have depth 6
    And the :proportion stack should be ["0.1", "0.2", "0.3", "0.4", "0.5", "0.3"]
    
    
  Scenario: negative pointer -> duplicate the top item
    Given I have pushed "0.1" onto the :proportion stack
    And I have pushed "0.2" onto the :proportion stack
    And I have pushed "0.3" onto the :proportion stack
    And I have pushed "0.4" onto the :proportion stack
    And I have pushed "0.5" onto the :proportion stack
    And I have pushed "-122" onto the :int stack
    When I execute the Nudge instruction "proportion_yankdup"
    Then stack :proportion should have depth 6
    And the :proportion stack should be ["0.1", "0.2", "0.3", "0.4", "0.5", "0.5"]
    
    
  Scenario: zero pointer -> duplicate the top item
    Given I have pushed "0.1" onto the :proportion stack
    And I have pushed "0.2" onto the :proportion stack
    And I have pushed "0.3" onto the :proportion stack
    And I have pushed "0.4" onto the :proportion stack
    And I have pushed "0.5" onto the :proportion stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "proportion_yankdup"
    Then stack :proportion should have depth 6
    And the :proportion stack should be ["0.1", "0.2", "0.3", "0.4", "0.5", "0.5"]
    
    
  Scenario: large positive pointer -> pull up a copy of the bottom item of the stack
    Given I have pushed "0.1" onto the :proportion stack
    And I have pushed "0.2" onto the :proportion stack
    And I have pushed "0.3" onto the :proportion stack
    And I have pushed "0.4" onto the :proportion stack
    And I have pushed "0.5" onto the :proportion stack
    And I have pushed "9922" onto the :int stack
    When I execute the Nudge instruction "proportion_yankdup"
    Then stack :proportion should have depth 6
    And the :proportion stack should be ["0.1", "0.2", "0.3", "0.4", "0.5", "0.1"]
  