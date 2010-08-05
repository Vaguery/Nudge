Feature: Just for push3 completeness
  In order to say we've got all the Push3 instructions available
  As a stickler for details
  I want Nudge to include the weird instructions from Push3
  
  
  Scenario: code_noop should do nothing
    Given the step counter is 11
    When I execute the Nudge instruction "code_noop"
    Then outcome_data should be unchanged
    But the step counter should be 12
