Feature: exec_shove instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to push things down into any given stack
    
  Scenario: positive pointer less than stack depth -> push the top item down N steps
    Given I have pushed "ref a" onto the :exec stack
    And I have pushed "ref b" onto the :exec stack
    And I have pushed "ref c" onto the :exec stack
    And I have pushed "ref d" onto the :exec stack
    And I have pushed "ref e" onto the :exec stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "exec_shove"
    Then stack :exec should have depth 5
    And the :exec stack should be ["ref a", "ref b", "ref e", "ref c", "ref d"]
    
    
  Scenario: negative pointer -> do nothing
    Given I have pushed "ref a" onto the :exec stack
    And I have pushed "ref b" onto the :exec stack
    And I have pushed "ref c" onto the :exec stack
    And I have pushed "ref d" onto the :exec stack
    And I have pushed "ref e" onto the :exec stack
    And I have pushed "-2" onto the :int stack
    When I execute the Nudge instruction "exec_shove"
    Then stack :exec should have depth 5
    And the :exec stack should be ["ref a", "ref b", "ref c", "ref d", "ref e"]
    
    
  Scenario: zero pointer -> do nothing
    Given I have pushed "ref a" onto the :exec stack
    And I have pushed "ref b" onto the :exec stack
    And I have pushed "ref c" onto the :exec stack
    And I have pushed "ref d" onto the :exec stack
    And I have pushed "ref e" onto the :exec stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "exec_shove"
    Then stack :exec should have depth 5
    And the :exec stack should be ["ref a", "ref b", "ref c", "ref d", "ref e"]
    
    
  Scenario: large positive pointer -> push the top item to the bottom of the stack
    Given I have pushed "ref a" onto the :exec stack
    And I have pushed "ref b" onto the :exec stack
    And I have pushed "ref c" onto the :exec stack
    And I have pushed "ref d" onto the :exec stack
    And I have pushed "ref e" onto the :exec stack
    And I have pushed "9900002" onto the :int stack
    When I execute the Nudge instruction "exec_shove"
    Then stack :exec should have depth 5
    And the :exec stack should be ["ref e", "ref a", "ref b", "ref c", "ref d"]
