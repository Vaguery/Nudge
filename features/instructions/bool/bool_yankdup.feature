Feature: bool_yankdup instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to pull things up from down inside any given stack
    
  Scenario: positive pointer less than stack depth -> pull up a copy of item at depth N to the top
    Given I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "false" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "bool_yankdup"
    Then stack :bool should have depth 6
    And the :bool stack should be ["true", "true", "false", "true", "true", "false"]
    
    
  Scenario: negative pointer -> duplicate the top item
    Given I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "false" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "-3" onto the :int stack
    When I execute the Nudge instruction "bool_yankdup"
    Then stack :bool should have depth 6
    And the :bool stack should be ["true", "true", "false", "true", "true", "true"]
    
    
  Scenario: zero pointer -> duplicate the top item
    Given I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "false" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "bool_yankdup"
    Then stack :bool should have depth 6
    And the :bool stack should be ["true", "true", "false", "true", "true", "true"]
    
    
  Scenario: large positive pointer -> pull up a copy of the bottom item of the stack
    Given I have pushed "false" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "true" onto the :bool stack
    And I have pushed "771281" onto the :int stack
    When I execute the Nudge instruction "bool_yankdup"
    Then stack :bool should have depth 6
    And the :bool stack should be ["false", "true", "true", "true", "true", "false"]
    
