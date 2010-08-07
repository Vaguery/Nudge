Feature: Bool flush
  In order to work from a clean slate within a run
  As a modeler
  I want a Nudge instruction to eliminate all entries at once from a given stack

  Scenario: cleans out everything when there is anything
    Given I have pushed "false" onto the :bool stack
    And I have pushed "false" onto the :bool stack
    When I execute the Nudge instruction "bool_flush"
    Then stack :bool should have depth 0
  
  
  Scenario: still runs (and doesn't complain) when the stack is empty
    When I execute the Nudge instruction "bool_flush"
    Then stack :bool should have depth 0
    And stack :error should have depth 0
