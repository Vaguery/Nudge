Feature: Code 'list' manipulation
  In order to emulate the classical LISP-like languages
  As a modeler
  I want Nudge instructions for car, cdr, cons and related methods
  
  
  Scenario: code_car should return the 1st element of a program with 2 or more points
    Given an interpreter with "block {block {ref x} ref y ref z}" on the :code stack
    When I execute "do code_car"
    Then the item on the :code stack should have value "block {ref x}"
    And the original argument should be gone
    
    
  Scenario: code_car should return a copy of a 1-point program
    Given an interpreter with "block {}" on the :code stack
    When I execute "do code_car"
    Then the item on the :code stack should have value "block {}"
    And the original argument should be gone
    
    
  Scenario: code_car should return a copy of a reference
    Given an interpreter with "ref d" on the :code stack
    When I execute "do code_car"
    Then the item on the :code stack should have value "ref d"
    And the original argument should be gone
    
    
  Scenario: code_car should return a copy of an instruction
    Given an interpreter with "do bool_flush" on the :code stack
    When I execute "do code_car"
    Then the item on the :code stack should have value "do bool_flush"
    And the original argument should be gone
    
    
  Scenario: code_car should return a copy of a value
    Given an interpreter with "value «bool»\n«bool» false" on the :code stack
    When I execute "do code_car"
    Then the item on the :code stack should have value "value «bool»\n«bool» false"
    And the original argument should be gone
    
    
  Scenario: code_car should return an error value for an unparseable program
    Given an interpreter with "12345 67 8 9" on the :code stack
    When I execute "do code_car"
    Then the original argument should be gone
    And the :error stack should contain "code_car attempted on unparseable program"
    
    
    
  Scenario: code_cdr should delete the 1st element of a program with 2 or more points
    Given an interpreter with "block {block {ref x} ref y ref z}" on the :code stack
    When I execute "do code_cdr"
    Then the item on the :code stack should have value "block {ref y ref z}"
    And the original argument should be gone
    
    
  Scenario: code_cdr should return an empty block when the argument is a 1-point block
    Given an interpreter with "block {}" on the :code stack
    When I execute "do code_cdr"
    Then the item on the :code stack should have value "block {}"
    And the original argument should be gone
    
    
  Scenario: code_cdr should return an empty block when the argument is a reference
    Given an interpreter with "ref x" on the :code stack
    When I execute "do code_cdr"
    Then the item on the :code stack should have value "block {}"
    And the original argument should be gone
    
    
  Scenario: code_cdr should return an empty block when the argument is an instruction
    Given an interpreter with "do float_subtract" on the :code stack
    When I execute "do code_cdr"
    Then the item on the :code stack should have value "block {}"
    And the original argument should be gone
    
    
  Scenario: code_cdr should return an empty block when the argument is a value
    Given an interpreter with "value «code»\n«code» block {ref x}" on the :code stack
    When I execute "do code_cdr"
    Then the item on the :code stack should have value "block {}"
    And the original argument should be gone
    
    
  Scenario: code_cdr should return an :error when the argument is unparseable
    Given an interpreter with "flibbertigibbet" on the :code stack
    When I execute "do code_cdr"
    Then the original argument should be gone
    And the :error stack should contain "code_cdr attempted on unparseable program"
    
    
    
  Scenario: code_concatenate should concatenate two blocks
    Given an interpreter with "block {ref x}" on the :code stack
    And "block {do a}" above that
    When I execute "do code_concatenate"
    Then the original arguments should be gone
    And the :code stack should contain "block {ref x do a}"
    
    
  Scenario: code_concatenate should append a non-block item to a block
    Given an interpreter with "block {ref x}" on the :code stack
    And "value «int»\n«int» 8" above that
    When I execute "do code_concatenate"
    Then the original arguments should be gone
    And the :code stack should contain "block {ref x value «int»} \n«int» 8"
    
    
  Scenario: code_concatenate should create a new block when the first argument is not one
    Given an interpreter with "do a" on the :code stack
    And "block {ref x}" above that
    When I execute "do code_concatenate"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a block {ref x}}"
    
    
  Scenario: code_concatenate should create a new block when neither is one
    Given an interpreter with "do a" on the :code stack
    And "ref b" above that
    When I execute "do code_concatenate"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a ref b}"
    
    
    
  Scenario: code_cons should insert the 1st argument into the first position in a 2nd argument block
    Given an interpreter with "do a" on the :code stack
    And "block {ref x ref y}" above that
    When I execute "do code_cons"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a ref x ref y}"
    
    
  Scenario: code_cons should insert a block 1st argument into the first position in a 2nd argument block
    Given an interpreter with "block {do foo}" on the :code stack
    And "block {ref x ref y}" above that
    When I execute "do code_cons"
    Then the original arguments should be gone
    And the :code stack should contain "block {block {do foo} ref x ref y}"
    
    
  Scenario: code_cons should wrap the second argument in a block if it isn't already in one
    Given an interpreter with "ref x" on the :code stack
    And "do int_add" above that
    When I execute "do code_cons"
    Then the original arguments should be gone
    And the :code stack should contain "block {ref x do int_add}"
    
    
  Scenario: code_cons should handle nested blocks correctly
    Given an interpreter with "block {block {}}" on the :code stack
    And "do int_add" above that
    When I execute "do code_cons"
    Then the original arguments should be gone
    And the :code stack should contain "block {block {block {}} do int_add}"
    
    
    
    