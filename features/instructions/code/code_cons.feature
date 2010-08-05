Feature: code_cons instruction
  In order to treat Nudge blocks like LISP lists
  As a Push3 user
  I want a Nudge instruction that act like LISP's "cons"
    
    
  Scenario: code_cons should insert the 1st argument into the first position in a 2nd argument block
    Given I have pushed "do a" onto the :code stack
    And I have pushed "block {ref x ref y}" onto the :code stack
    When I execute the Nudge instruction "code_cons"
    Then "block {do a ref x ref y}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_cons should insert a block 1st argument into the first position in a 2nd argument block
    Given I have pushed "block {do foo}" onto the :code stack
    And I have pushed "block {ref x ref y}" onto the :code stack
    When I execute the Nudge instruction "code_cons"
    Then "block {block {do foo} ref x ref y}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_cons should wrap the second argument in a block if it isn't already in one
    Given I have pushed "ref x" onto the :code stack
    And I have pushed "do int_add" onto the :code stack
    When I execute the Nudge instruction "code_cons"
    Then "block {ref x do int_add}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_cons should handle nested blocks correctly
    Given I have pushed "block {block {}}" onto the :code stack
    And I have pushed "do int_add" onto the :code stack
    When I execute the Nudge instruction "code_cons"
    Then "block {block {block {}} do int_add}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_cons should return an :error when it can't parse arg1
    Given I have pushed "not my affair" onto the :code stack
    And I have pushed "do int_add" onto the :code stack
    When I execute the Nudge instruction "code_cons"
    Then "code_cons cannot parse an argument" should be in position -1 of the :error stack
    And stack :code should have depth 0
    
    
  Scenario: code_cons should return an :error when it can't parse arg2
    Given I have pushed "do int_add" onto the :code stack
    And I have pushed "abc defgh" onto the :code stack
    When I execute the Nudge instruction "code_cons"
    Then "code_cons cannot parse an argument" should be in position -1 of the :error stack
    And stack :code should have depth 0
