Feature: exec_yankdup instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to pull things up from down inside any given stack
    
  Scenario: positive pointer less than stack depth -> pull up a copy of item at depth N to the top
    Given I have pushed "ref a" onto the :exec stack
    And I have pushed "ref b" onto the :exec stack
    And I have pushed "ref c" onto the :exec stack
    And I have pushed "ref d" onto the :exec stack
    And I have pushed "ref e" onto the :exec stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "exec_yankdup"
    Then stack :exec should have depth 6
    And the :exec stack should be ["ref a", "ref b", "ref c", "ref d", "ref e", "ref c"]
    And there should be no repeated object_ids in the :exec stack
    
    
  Scenario: negative pointer -> duplicate the top item
    Given I have pushed "ref a" onto the :exec stack
    And I have pushed "ref b" onto the :exec stack
    And I have pushed "ref c" onto the :exec stack
    And I have pushed "ref d" onto the :exec stack
    And I have pushed "ref e" onto the :exec stack
    And I have pushed "-2" onto the :int stack
    When I execute the Nudge instruction "exec_yankdup"
    Then stack :exec should have depth 6
    And the :exec stack should be ["ref a", "ref b", "ref c", "ref d", "ref e", "ref e"]
    And there should be no repeated object_ids in the :exec stack
    
    
  Scenario: zero pointer -> duplicate the top item
    Given I have pushed "ref a" onto the :exec stack
    And I have pushed "ref b" onto the :exec stack
    And I have pushed "ref c" onto the :exec stack
    And I have pushed "ref d" onto the :exec stack
    And I have pushed "ref e" onto the :exec stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "exec_yankdup"
    Then stack :exec should have depth 6
    And the :exec stack should be ["ref a", "ref b", "ref c", "ref d", "ref e", "ref e"]
    And there should be no repeated object_ids in the :exec stack
    
    
  Scenario: large positive pointer -> pull up a copy of the bottom item of the stack
    Given I have pushed "ref a" onto the :exec stack
    And I have pushed "ref b" onto the :exec stack
    And I have pushed "ref c" onto the :exec stack
    And I have pushed "ref d" onto the :exec stack
    And I have pushed "ref e" onto the :exec stack
    And I have pushed "88182" onto the :int stack
    When I execute the Nudge instruction "exec_yankdup"
    Then stack :exec should have depth 6
    And the :exec stack should be ["ref a", "ref b", "ref c", "ref d", "ref e", "ref a"]
    And there should be no repeated object_ids in the :exec stack
  