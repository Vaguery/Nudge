Feature: code_yank instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to pull things up from down inside any given stack
    
  Scenario: positive pointer less than stack depth -> pull up item at depth N to the top
    Given I have pushed "ref a" onto the :code stack
    And I have pushed "ref b" onto the :code stack
    And I have pushed "ref c" onto the :code stack
    And I have pushed "ref d" onto the :code stack
    And I have pushed "ref e" onto the :code stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "code_yank"
    Then stack :code should have depth 5
    And the :code stack should be ["ref a", "ref b", "ref d", "ref e", "ref c"]
    
    
  Scenario: negative pointer -> do nothing
    Given I have pushed "ref a" onto the :code stack
    And I have pushed "ref b" onto the :code stack
    And I have pushed "ref c" onto the :code stack
    And I have pushed "ref d" onto the :code stack
    And I have pushed "ref e" onto the :code stack
    And I have pushed "-3" onto the :int stack
    When I execute the Nudge instruction "code_yank"
    Then stack :code should have depth 5
    And the :code stack should be ["ref a", "ref b", "ref c", "ref d", "ref e"]
    
    
  Scenario: zero pointer -> do nothing
    Given I have pushed "ref a" onto the :code stack
    And I have pushed "ref b" onto the :code stack
    And I have pushed "ref c" onto the :code stack
    And I have pushed "ref d" onto the :code stack
    And I have pushed "ref e" onto the :code stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "code_yank"
    Then stack :code should have depth 5
    And the :code stack should be ["ref a", "ref b", "ref c", "ref d", "ref e"]
    
    
  Scenario: large positive pointer -> pull up the bottom item of the stack
    Given I have pushed "ref a" onto the :code stack
    And I have pushed "ref b" onto the :code stack
    And I have pushed "ref c" onto the :code stack
    And I have pushed "ref d" onto the :code stack
    And I have pushed "ref e" onto the :code stack
    And I have pushed "2998181" onto the :int stack
    When I execute the Nudge instruction "code_yank"
    Then stack :code should have depth 5
    And the :code stack should be ["ref b", "ref c", "ref d", "ref e", "ref a"]
    
