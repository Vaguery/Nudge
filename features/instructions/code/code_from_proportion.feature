Feature: Code from proportion
  In order to manipulate items indirectly
  As a modeler
  I want Nudge to have a code_from_proportion instruction
  
  Scenario: simple enough
    Given I have pushed "0.888" onto the :proportion stack
    When I execute the Nudge instruction "code_from_proportion"
    Then stack :proportion should have depth 0
    And "value «proportion»\n«proportion» 0.888" should be in position -1 of the :code stack