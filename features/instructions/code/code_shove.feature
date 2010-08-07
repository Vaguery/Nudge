Feature: code_shove instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to push things down into any given stack
    
  Scenario: positive pointer less than stack depth -> push the top item down N steps
    Given I have pushed "ref a" onto the :code stack
    And I have pushed "ref b" onto the :code stack
    And I have pushed "ref c" onto the :code stack
    And I have pushed "ref d" onto the :code stack
    And I have pushed "ref e" onto the :code stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "code_shove"
    Then stack :code should have depth 5
    And the :code stack should be ["ref a", "ref b", "ref e", "ref c", "ref d"]
    
    
  Scenario: negative pointer -> do nothing
    Given I have pushed "ref a" onto the :code stack
    And I have pushed "ref b" onto the :code stack
    And I have pushed "ref c" onto the :code stack
    And I have pushed "ref d" onto the :code stack
    And I have pushed "ref e" onto the :code stack
    And I have pushed "-2" onto the :int stack
    When I execute the Nudge instruction "code_shove"
    Then stack :code should have depth 5
    And the :code stack should be ["ref a", "ref b", "ref c", "ref d", "ref e"]
    
    
  Scenario: zero pointer -> do nothing
    Given I have pushed "ref a" onto the :code stack
    And I have pushed "ref b" onto the :code stack
    And I have pushed "ref c" onto the :code stack
    And I have pushed "ref d" onto the :code stack
    And I have pushed "ref e" onto the :code stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "code_shove"
    Then stack :code should have depth 5
    And the :code stack should be ["ref a", "ref b", "ref c", "ref d", "ref e"]
    
    
  Scenario: large positive pointer -> push the top item to the bottom of the stack
    Given I have pushed "ref a" onto the :code stack
    And I have pushed "ref b" onto the :code stack
    And I have pushed "ref c" onto the :code stack
    And I have pushed "ref d" onto the :code stack
    And I have pushed "ref e" onto the :code stack
    And I have pushed "9900002" onto the :int stack
    When I execute the Nudge instruction "code_shove"
    Then stack :code should have depth 5
    And the :code stack should be ["ref e", "ref a", "ref b", "ref c", "ref d"]
    