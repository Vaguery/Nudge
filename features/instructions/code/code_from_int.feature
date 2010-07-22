Feature: Code from int
  In order to manipulate items indirectly
  As a modeler
  I want Nudge to have a code_from_int instruction
  
  Scenario: simple enough
    Given I have pushed "1000" onto the :int stack
    When I execute the Nudge instruction "code_from_int"
    Then stack :int should have depth 0
    And "value «int»\n«int» 1000" should be in position -1 of the :code stack