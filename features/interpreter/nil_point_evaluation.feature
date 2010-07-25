Feature: Nil point evaluation
  In order to manage edge cases where bad code has been created
  As a modeler
  I want the execution loop to handle NilPoints gracefully


  Scenario: NilPoints just go away
    Given I have pushed "end of line" onto the :exec stack
    When I take one execution step
    Then stack :exec should have depth 0
    And the execution counter should be 1
