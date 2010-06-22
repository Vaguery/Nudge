Feature: Just for push3 completeness
  In order to say we've got all the Push3 instructions available
  As a stickler for details
  I want Nudge to include the weird instructions from Push3
  
  
  Scenario: code_instructions should create a block containing one call of (almost) every active instruction
    Given an interpreter with int_add, int_subtract and code_instructions activated
    When I execute "do code_instructions"
    Then the :code stack should contain "block {do int_add do int_subtract}"
    But that block should not contain "do code_instructions"
    
    
  Scenario: code_instructions should produce the list in alphabetical order
    Given an interpreter with int_bbb, int_aaa and int_ccc activated
    When I execute "do code_instructions"
    Then the :code stack should contain "block {do int_aaa do int_bbb do int_ccc}"
    
    
    
    
    
    
  Scenario: code_noop should do nothing
    Given an interpreter
    When I execute "do code_noop"
    Then there should be no change
    But the interpreter's step counter should increment
