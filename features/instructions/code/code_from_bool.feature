Feature: Code from bool
  In order to manipulate items indirectly
  As a modeler
  I want Nudge to have a code_from_bool instruction
  
  Scenario: simple enough
    Given I have pushed "false" onto the :bool stack
    When I execute the Nudge instruction "code_from_bool"
    Then stack :bool should have depth 0
    And "value «bool»\n«bool» false" should be in position -1 of the :code stack