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
    
    
    
  Scenario: code_container should return the first block that contains the 2nd arg in its root
    Given an interpreter with "block {block {do a ref x}}" on the :code stack
    And "ref x" above that
    When I execute "do code_container"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a ref x}"
    
    
  Scenario: code_container should return an empty block if the 2nd arg is not found
    Given an interpreter with "block {block {do a ref x}}" on the :code stack
    And "ref z" above that
    When I execute "do code_container"
    Then the original arguments should be gone
    And the :code stack should contain "block {}"
    
    
  Scenario: code_container should return the first block found by breadth-first search
    Given an interpreter with "block {block {do a ref z} ref z}" on the :code stack
    And "ref z" above that
    When I execute "do code_container"
    Then the original arguments should be gone
    And the :code stack should contain "block {block {do a ref z} ref z}"
    
    
  Scenario: code_container should return all associated block structure
    Given an interpreter with "block {block {ref z block {} ref z} ref w}" on the :code stack
    And "ref z" above that
    When I execute "do code_container"
    Then the original arguments should be gone
    And the :code stack should contain "block {ref z block {} ref z}"
    
    
  Scenario: code_container should return the correct footnotes
    Given an interpreter with "block {block {value «int» ref x}} \n«int» 99" on the :code stack
    And "ref x" above that
    When I execute "do code_container"
    Then the original arguments should be gone
    And the :code stack should contain "block {value «int» ref x} \n«int» 99"
    
    
  Scenario: code_container should return the entire arg1 if they're identical
    Given an interpreter with "block {block {value «int» ref x}} \n«int» 99" on the :code stack
    And "block {block {value «int» ref x}} \n«int» 99" above that
    When I execute "do code_container"
    Then the original arguments should be gone
    And the :code stack should contain "block {block {value «int» ref x}} \n«int» 99"
    
    
    
  Scenario: code_gsub should replace all subtrees in arg1 matching arg2 with arg3
    Given an interpreter with "block {ref x ref y ref x}" on the :code stack
    And "ref x" above that
    And "do a" above that
    When I execute "do code_gsub"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a ref y do a}"
    
    
  Scenario: code_gsub should traverse subtrees in arg1
    Given an interpreter with "block {ref x block {ref y block {ref x}}}" on the :code stack
    And "ref x" above that
    And "do a" above that
    When I execute "do code_gsub"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a block {ref y block {do a}}}"
    
    
  Scenario: code_gsub should not search code in footnotes
    Given an interpreter with "block {value «code»} \n«code ref x" on the :code stack
    And "ref x" above that
    And "do a" above that
    When I execute "do code_gsub"
    Then the original arguments should be gone
    And the :code stack should contain "block {value «code»} \n«code ref x"
    
    
  Scenario: code_gsub should replace footnotes as appropriate
    Given an interpreter with "block {value «code» value «int»} \n«code ref x \n«int» 9" on the :code stack
    And "value «int» \n «int» 9" above that
    And "do a" above that
    When I execute "do code_gsub"
    Then the original arguments should be gone
    And the :code stack should contain "block {value «code» do a} \n«code ref x"
    
    
  Scenario: code_gsub should return an :error if arg1 is unparseable
    Given an interpreter with "rooty toot toot" on the :code stack
    And "value «int» \n «int» 9" above that
    And "do a" above that
    When I execute "do code_gsub"
    Then the original arguments should be gone
    And the :error stack should contain "code_gsub cannot parse an argument"
    
    
  Scenario: code_gsub should return an :error if arg2 is unparseable
    Given an interpreter with "ref x" on the :code stack
    And "hoo dee doo" above that
    And "do a" above that
    When I execute "do code_gsub"
    Then the original arguments should be gone
    And the :error stack should contain "code_gsub cannot parse an argument"
    
    
  Scenario: code_gsub should return an :error if arg3 is unparseable
    Given an interpreter with "ref x" on the :code stack
    And "do a" above that
    And "tra la la" above that
    When I execute "do code_gsub"
    Then the original arguments should be gone
    And the :error stack should contain "code_gsub cannot parse an argument"
    
    
    
  Scenario: code_list should return a block with both arguments in order as root elements
    Given an interpreter with "ref x" on the :code stack
    And "do a" above that
    When I execute "do code_list"
    Then the original arguments should be gone
    And the :code stack should contain "block {ref x do a}"
    
    
  Scenario: code_list should work as expected with block arguments
    Given an interpreter with "block {ref x}" on the :code stack
    And "block {do a}" above that
    When I execute "do code_list"
    Then the original arguments should be gone
    And the :code stack should contain "block {block {ref x} block {do a}}"
    
    
    
  Scenario: code_nth should return the nth backbone element (1-based) of a :code item
    Given an interpreter with "block {do a do b do c}" on the :code stack
    And "1" on the :int stack
    When I execute "do code_nth"
    Then the original arguments should be gone
    And the :code stack should contain "do a"
    
    
  Scenario: code_nth should take n modulo the number of items in the backbone
    Given an interpreter with "block {do a do b do c}" on the :code stack
    And "-29" on the :int stack
    When I execute "do code_nth"
    Then the original arguments should be gone
    And the :code stack should contain "do a"
      
      
  Scenario: code_nth should not affect a non-block argument
    Given an interpreter with "do int_add" on the :code stack
    And "33" on the :int stack
    When I execute "do code_nth"
    Then the original arguments should be gone
    And the :code stack should contain "do int_add"
    
    
  Scenario: code_nth should create an error if an empty block is the arg
    Given an interpreter with "block {}" on the :code stack
    And "2" on the :int stack
    When I execute "do code_nth"
    Then the original arguments should be gone
    And the :error stack should contain "code_nth cannot work on empty blocks"
    
    
    
  Scenario: code_nth_cdr should return the nth cdr of a block
    Given an interpreter with "block {do a do b do c}" on the :code stack
    And "2" on the :int stack
    When I execute "do code_nth_cdr"
    Then the original arguments should be gone
    And the :code stack should contain "block {do c}"
    
    
  Scenario: code_nth_cdr should wrap a statement in a block first
    Given an interpreter with "do int_add" on the :code stack
    And "1" on the :int stack
    When I execute "do code_nth_cdr"
    Then the original arguments should be gone
    And the :code stack should contain "block {}"
    
    
  Scenario: code_nth_cdr should take n modulo the length of the block's backbone
    Given an interpreter with "block {do a do b do c}" on the :code stack
    And "4" on the :int stack
    When I execute "do code_nth_cdr"
    Then the original arguments should be gone
    And the :code stack should contain "block {do b do c}"
    
    
  Scenario: code_nth_cdr should return the arg intact for non-positive n
    Given an interpreter with "block {do a do b do c}" on the :code stack
    And "-4" on the :int stack
    When I execute "do code_nth_cdr"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a do b do c}"
