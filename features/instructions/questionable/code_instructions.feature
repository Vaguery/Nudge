Feature: code_instructions instruction
  In order to say we've got all the Push3 instructions available
  As a stickler for details
  I want Nudge to include the questionably weird instructions from Push3
  
  
  Scenario: code_instructions should create a block containing one call of (almost) every active instruction
    Given I have deactivated all instructions
    And I have activated the "int_subtract" instruction
    And I have activated the "bool_or" instruction
    And I have activated the "int_add" instruction
    When I execute the Nudge instruction "code_instructions"
    Then "block {do bool_or do int_add do int_subtract}" should be in position 0 of the :code stack
    And stack :code should have depth 1