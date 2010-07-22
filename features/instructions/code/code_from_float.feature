Feature: Code from float
  In order to manipulate items indirectly
  As a modeler
  I want Nudge to have a code_from_float instruction
  
  Scenario: simple enough
    Given I have pushed "1.234" onto the :float stack
    When I execute the Nudge instruction "code_from_float"
    Then stack :float should have depth 0
    And "value «float»\n«float» 1.234" should be in position -1 of the :code stack