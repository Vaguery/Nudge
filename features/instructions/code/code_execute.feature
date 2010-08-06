Feature: code_execute instruction
  In order to run stored :code items
  As a modeler
  I want Nudge to include instructions for moving :code to and from :exec
  
  
  Scenario: code_execute should move the top :code item to :exec
    Given I have pushed "do int_add" onto the :code stack
    When I execute the Nudge instruction "code_execute"
    Then "do int_add" should be in position 0 of the :exec stack
    And stack :exec should have depth 1
    And stack :code should have depth 0
