Feature: Exec flush
  In order to work from a clean slate within a run
  As a modeler
  I want a Nudge instruction to eliminate all entries at once from a given stack

  Scenario: cleans out everything when there is anything
    Given I have pushed "ref a" onto the :exec stack
    And I have pushed "ref b" onto the :exec stack
    When I execute the Nudge instruction "exec_flush"
    Then stack :exec should have depth 0
  
  
  Scenario: still runs (and doesn't complain) when the stack is empty
    When I execute the Nudge instruction "exec_flush"
    Then stack :exec should have depth 0
    And stack :error should have depth 0
