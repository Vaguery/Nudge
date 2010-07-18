Feature: code_cdr instruction
  In order to treat Nudge blocks like LISP lists
  As a Push3 user
  I want a Nudge instruction that act like LISP's "cdr"
    
  Scenario: code_cdr should delete the 1st internal element of a code value point
    Given I have pushed "block {block {ref x} ref y ref z}" onto the :code stack
    When I execute the Nudge instruction "code_cdr"
    Then "block { ref y ref z }" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_cdr should return an empty block when the argument is a 1-point block
    Given I have pushed "block {}" onto the :code stack
    When I execute the Nudge instruction "code_cdr"
    Then "block {}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_cdr should return an empty block when the argument is a reference
    Given I have pushed "ref x" onto the :code stack
    When I execute the Nudge instruction "code_cdr"
    Then "block {}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_cdr should return an empty block when the argument is an instruction
    Given I have pushed "do float_subtract" onto the :code stack
    When I execute the Nudge instruction "code_cdr"
    Then "block {}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_cdr should return an empty block when the argument is a value
    Given I have pushed "value «code»\n«code» block {ref x}" onto the :code stack
    When I execute the Nudge instruction "code_cdr"
    Then "block {}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_cdr should return an :error when the argument is unparseable
    Given I have pushed "flibbertigibbet" onto the :code stack
    When I execute the Nudge instruction "code_cdr"
    Then stack :code should have depth 0
    And "code_cdr cannot parse an argument" should be in position -1 of the :error stack
