Feature: Code depth
  In order to give scripts a bit of introspective capacity
  As a modeler
  I want Nudge to include instructions for counting things on stacks

  Scenario: works as expected
    Given I have pushed "ref a" onto the :code stack
    And I have pushed "ref b" onto the :code stack
    When I execute the Nudge instruction "code_depth"
    Then "2" should be in position -1 of the :int stack
  
  Scenario: returns 0 for an empty stack
    When I execute the Nudge instruction "code_depth"
    Then "0" should be in position -1 of the :int stack