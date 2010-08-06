Feature: Just for push3 completeness
  In order to say we've got all the Push3 instructions available
  As a stickler for details
  I want Nudge to include the weird instructions from Push3
  
  
  Scenario: code_noop should do nothing
    Given the execution counter is set to 11
    When I execute the Nudge instruction "code_noop"
    Then stack :exec should have depth 0
    And stack :error should have depth 0
    And the execution counter should be 12
