

Scenario: nil point handling
  Given an interpreter with "end of line" on the :exec stack
  When I take an execution step
  Then a new :error value "cannot parse 'end of line'" should appear on the :error stack
