Feature: Code 'list' manipulation
  In order to emulate the classical LISP-like languages
  As a modeler
  I want Nudge instructions for car, cdr, cons and related methods
  
  
  Scenario: code_car should return the 1st element of a program with 2 or more points
    Given I have pushed "block {block {ref x} ref y ref z}" onto the :code stack
    When I execute the Nudge instruction "code_car"
    Then "block { ref x }" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_car should return a copy of a 1-point program
    Given I have pushed "block {}" onto the :code stack
    When I execute the Nudge instruction "code_car"
    Then "block {}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_car should return a copy of a reference
    Given I have pushed "ref d" onto the :code stack
    When I execute the Nudge instruction "code_car"
    Then "ref d" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_car should return a copy of an instruction
    Given I have pushed "do bool_flush" onto the :code stack
    When I execute the Nudge instruction "code_car"
    Then "do bool_flush" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_car should return a copy of a value
    Given I have pushed "value «bool»\n«bool» false" onto the :code stack
    When I execute the Nudge instruction "code_car"
    Then "value «bool»\n«bool» false" should be in position 0 of the :code stack
    
    
    
    
    
    
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
    Then the item on the :code stack should have value "block {}"
    And the original argument should be gone
    
    
  Scenario: code_cdr should return an empty block when the argument is an instruction
    Given I have pushed "do float_subtract" onto the :code stack
    When I execute the Nudge instruction "code_cdr"
    Then the item on the :code stack should have value "block {}"
    And the original argument should be gone
    
    
  Scenario: code_cdr should return an empty block when the argument is a value
    Given I have pushed "value «code»\n«code» block {ref x}" onto the :code stack
    When I execute the Nudge instruction "code_cdr"
    Then the item on the :code stack should have value "block {}"
    And the original argument should be gone
    
    
    
    
    
    
  Scenario: code_concatenate should concatenate two blocks
    Given I have pushed "block {ref x}" onto the :code stack
    And I have pushed "block {do a}" onto the :code stack
    When I execute the Nudge instruction "code_concatenate"
    Then the original arguments should be gone
    And the :code stack should contain "block {ref x do a}"
    
    
  Scenario: code_concatenate should append a non-block item to a block
    Given I have pushed "block {ref x}" onto the :code stack
    And I have pushed "value «int»\n«int» 8" onto the :code stack
    When I execute the Nudge instruction "code_concatenate"
    Then the original arguments should be gone
    And the :code stack should contain "block {ref x value «int»} \n«int» 8"
    
    
  Scenario: code_concatenate should create a new block when the first argument is not one
    Given I have pushed "do a" onto the :code stack
    And I have pushed "block {ref x}" onto the :code stack
    When I execute the Nudge instruction "code_concatenate"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a block {ref x}}"
    
    
  Scenario: code_concatenate should create a new block when neither is one
    Given I have pushed "do a" onto the :code stack
    And I have pushed "ref b" onto the :code stack
    When I execute the Nudge instruction "code_concatenate"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a ref b}"
    
    
    
    
    
    
  Scenario: code_cons should insert the 1st argument into the first position in a 2nd argument block
    Given I have pushed "do a" onto the :code stack
    And I have pushed "block {ref x ref y}" onto the :code stack
    When I execute the Nudge instruction "code_cons"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a ref x ref y}"
    
    
  Scenario: code_cons should insert a block 1st argument into the first position in a 2nd argument block
    Given I have pushed "block {do foo}" onto the :code stack
    And I have pushed "block {ref x ref y}" onto the :code stack
    When I execute the Nudge instruction "code_cons"
    Then the original arguments should be gone
    And the :code stack should contain "block {block {do foo} ref x ref y}"
    
    
  Scenario: code_cons should wrap the second argument in a block if it isn't already in one
    Given I have pushed "ref x" onto the :code stack
    And I have pushed "do int_add" onto the :code stack
    When I execute the Nudge instruction "code_cons"
    Then the original arguments should be gone
    And the :code stack should contain "block {ref x do int_add}"
    
    
  Scenario: code_cons should handle nested blocks correctly
    Given I have pushed "block {block {}}" onto the :code stack
    And I have pushed "do int_add" onto the :code stack
    When I execute the Nudge instruction "code_cons"
    Then the original arguments should be gone
    And the :code stack should contain "block {block {block {}} do int_add}"
    
    
    
    
    
    
  Scenario: code_container should return the first block that contains the 2nd arg in its root
    Given I have pushed "block {block {do a ref x}}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    When I execute the Nudge instruction "code_container"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a ref x}"
    
    
  Scenario: code_container should return an empty block if the 2nd arg is not found
    Given I have pushed "block {block {do a ref x}}" onto the :code stack
    And I have pushed "ref z" onto the :code stack
    When I execute the Nudge instruction "code_container"
    Then the original arguments should be gone
    And the :code stack should contain "block {}"
    
    
  Scenario: code_container should return the first block found by breadth-first search
    Given I have pushed "block {block {do a ref z} ref z}" onto the :code stack
    And I have pushed "ref z" onto the :code stack
    When I execute the Nudge instruction "code_container"
    Then the original arguments should be gone
    And the :code stack should contain "block {block {do a ref z} ref z}"
    
    
  Scenario: code_container should return all associated block structure
    Given I have pushed "block {block {ref z block {} ref z} ref w}" onto the :code stack
    And I have pushed "ref z" onto the :code stack
    When I execute the Nudge instruction "code_container"
    Then the original arguments should be gone
    And the :code stack should contain "block {ref z block {} ref z}"
    
    
  Scenario: code_container should return the correct footnotes
    Given I have pushed "block {block {value «int» ref x}} \n«int» 99" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    When I execute the Nudge instruction "code_container"
    Then the original arguments should be gone
    And the :code stack should contain "block {value «int» ref x} \n«int» 99"
    
    
  Scenario: code_container should return the entire arg1 if they're identical
    Given I have pushed "block {block {value «int» ref x}} \n«int» 99" onto the :code stack
    And I have pushed "block {block {value «int» ref x}} \n«int» 99" onto the :code stack
    When I execute the Nudge instruction "code_container"
    Then the original arguments should be gone
    And the :code stack should contain "block {block {value «int» ref x}} \n«int» 99"
    
    
    
    
    
    
  Scenario: code_gsub should replace all subtrees in arg1 matching arg2 with arg3
    Given I have pushed "block {ref x ref y ref x}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    And I have pushed "do a" onto the :code stack
    When I execute the Nudge instruction "code_gsub"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a ref y do a}"
    
    
  Scenario: code_gsub should traverse subtrees in arg1
    Given I have pushed "block {ref x block {ref y block {ref x}}}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    And I have pushed "do a" onto the :code stack
    When I execute the Nudge instruction "code_gsub"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a block {ref y block {do a}}}"
    
    
  Scenario: code_gsub should not search code in footnotes
    Given I have pushed "block {value «code»} \n«code ref x" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    And I have pushed "do a" onto the :code stack
    When I execute the Nudge instruction "code_gsub"
    Then the original arguments should be gone
    And the :code stack should contain "block {value «code»} \n«code ref x"
    
    
  Scenario: code_gsub should replace footnotes as appropriate
    Given I have pushed "block {value «code» value «int»} \n«code ref x \n«int» 9" onto the :code stack
    And I have pushed "value «int» \n «int» 9" onto the :code stack
    And I have pushed "do a" onto the :code stack
    When I execute the Nudge instruction "code_gsub"
    Then the original arguments should be gone
    And the :code stack should contain "block {value «code» do a} \n«code ref x"
    
    
    
    
    
    
  Scenario: code_list should return a block with both arguments in order as root elements
    Given I have pushed "ref x" onto the :code stack
    And I have pushed "do a" onto the :code stack
    When I execute the Nudge instruction "code_list"
    Then the original arguments should be gone
    And the :code stack should contain "block {ref x do a}"
    
    
  Scenario: code_list should work as expected with block arguments
    Given I have pushed "block {ref x}" onto the :code stack
    And I have pushed "block {do a}" onto the :code stack
    When I execute the Nudge instruction "code_list"
    Then the original arguments should be gone
    And the :code stack should contain "block {block {ref x} block {do a}}"
    
    
    
    
    
    
  Scenario: code_nth should return the nth backbone element (0-based) of a :code item
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "code_nth"
    Then the original arguments should be gone
    And the :code stack should contain "do a"
    
    
  Scenario: code_nth should take n modulo the number of items in the backbone
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "5" onto the :int stack
    When I execute the Nudge instruction "code_nth"
    Then the original arguments should be gone
    And the :code stack should contain "do c"
      
      
  Scenario: code_nth should not affect a non-block argument
    Given I have pushed "do int_add" onto the :code stack
    And I have pushed "33" onto the :int stack
    When I execute the Nudge instruction "code_nth"
    Then the original arguments should be gone
    And the :code stack should contain "do int_add"
    
    
    
    
    
  Scenario: code_nth_cdr should return the nth cdr of a block
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "code_nth_cdr"
    Then the original arguments should be gone
    And the :code stack should contain "block {do c}"
    
    
  Scenario: code_nth_cdr should wrap a statement in a block first
    Given I have pushed "do int_add" onto the :code stack
    And I have pushed "1" onto the :int stack
    When I execute the Nudge instruction "code_nth_cdr"
    Then the original arguments should be gone
    And the :code stack should contain "block {}"
    
    
  Scenario: code_nth_cdr should take n modulo the length of the block's backbone
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "4" onto the :int stack
    When I execute the Nudge instruction "code_nth_cdr"
    Then the original arguments should be gone
    And the :code stack should contain "block {do b do c}"
    
    
  Scenario: code_nth_cdr should return the arg intact for non-positive n
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "-4" onto the :int stack
    When I execute the Nudge instruction "code_nth_cdr"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a do b do c}"
    
    
    
    
    
    
  Scenario: code_nth_point should return the nth point of a program (0-based)
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "code_nth_point"
    Then the original arguments should be gone
    And the :code stack should contain "do b"
    
    
  Scenario: code_nth_point should take n modulo the number of points
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "7" onto the :int stack
    When I execute the Nudge instruction "code_nth_point"
    Then the original arguments should be gone
    And the :code stack should contain "do c"
    
    
  Scenario: code_nth_point should take arg2 = 0 to mean the first point
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "code_nth_point"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a do b do c}"
    
    
  Scenario: code_nth_point should work as expected for negative arguments
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "-1" onto the :int stack
    When I execute the Nudge instruction "code_nth_point"
    Then the original arguments should be gone
    And the :code stack should contain "do c"
    
    
    
    
    
    
  Scenario: code_position should find the first (0-based) point identical to the 2nd argument in the 1st arg 
    Given I have pushed "block {do a block {do b}}" onto the :code stack
    And I have pushed "do b" onto the :code stack
    When I execute the Nudge instruction "code_position"
    Then the original arguments should be gone
    And the :int stack should contain "3"
    
    
  Scenario: code_position should return [WHAT?!] if the 2nd arg is not found
    Given I have pushed "block {do a block {do b}}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    When I execute the Nudge instruction "code_position"
    Then the original arguments should be gone
    And the :int stack should contain "[WHAT?!]"
    
    
    
    
    
    
  Scenario: code_replace_nth_point should replace the nth point (0-based) of :code arg1 with :code arg2
    Given I have pushed "block {do a block {do b}}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "code_replace_nth_point"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a ref x}"
    
    
  Scenario: code_replace_nth_point should take n modulo the number of points in the arg1 (0-based)
    Given I have pushed "block {do a block {do b}}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    And I have pushed "31" onto the :int stack
    When I execute the Nudge instruction "code_replace_nth_point"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a block {ref x}}"