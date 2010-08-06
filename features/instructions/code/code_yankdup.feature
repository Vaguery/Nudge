Feature: code_yankdup instruction
  In order to implement tricky stack-shuffling kinda algorithms
  As a modeler
  I want to be able to pull things up from down inside any given stack
    
  Scenario: positive pointer less than stack depth -> pull up a copy of item at depth N to the top
    Given I have pushed "ref a" onto the :code stack
    And I have pushed "ref b" onto the :code stack
    And I have pushed "ref c" onto the :code stack
    And I have pushed "ref d" onto the :code stack
    And I have pushed "ref e" onto the :code stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "code_yankdup"
    Then stack :code should have depth 6
    And the :code stack should be ["ref a", "ref b", "ref c", "ref d", "ref e", "ref c"]
    
    
  Scenario: negative pointer -> duplicate the top item
    Given I have pushed "ref a" onto the :code stack
    And I have pushed "ref b" onto the :code stack
    And I have pushed "ref c" onto the :code stack
    And I have pushed "ref d" onto the :code stack
    And I have pushed "ref e" onto the :code stack
    And I have pushed "-3" onto the :int stack
    When I execute the Nudge instruction "code_yankdup"
    Then stack :code should have depth 6
    And the :code stack should be ["ref a", "ref b", "ref c", "ref d", "ref e", "ref e"]
    
    
  Scenario: zero pointer -> duplicate the top item
    Given I have pushed "ref a" onto the :code stack
    And I have pushed "ref b" onto the :code stack
    And I have pushed "ref c" onto the :code stack
    And I have pushed "ref d" onto the :code stack
    And I have pushed "ref e" onto the :code stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "code_yankdup"
    Then stack :code should have depth 6
    And the :code stack should be ["ref a", "ref b", "ref c", "ref d", "ref e", "ref e"]
    
    
  Scenario: large positive pointer -> pull up a copy of the bottom item of the stack
    Given I have pushed "ref a" onto the :code stack
    And I have pushed "ref b" onto the :code stack
    And I have pushed "ref c" onto the :code stack
    And I have pushed "ref d" onto the :code stack
    And I have pushed "ref e" onto the :code stack
    And I have pushed "2998181" onto the :int stack
    When I execute the Nudge instruction "code_yankdup"
    Then stack :code should have depth 6
    And the :code stack should be ["ref a", "ref b", "ref c", "ref d", "ref e", "ref a"]
    
