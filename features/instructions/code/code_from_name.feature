Feature: Code from name
  In order to manipulate items indirectly
  As a modeler
  I want Nudge to have a code_from_name instruction
  
  Scenario: simple enough
    Given I have pushed "x1" onto the :name stack
    When I execute the Nudge instruction "code_from_name"
    Then stack :name should have depth 0
    And "ref x1" should be in position -1 of the :code stack