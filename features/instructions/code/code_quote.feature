Feature: code_quote instruction
  In order to run stored :code items
  As a modeler
  I want Nudge to include instructions for moving :code to and from :exec
    
    
  Scenario: code_quote should move the top :exec item to :code
    Given I have pushed "ref x" onto the :exec stack
    When I execute the Nudge instruction "code_quote"
    Then "ref x" should be in position 0 of the :code stack
    And that stack's depth should be 1
    And stack :exec should have depth 0
