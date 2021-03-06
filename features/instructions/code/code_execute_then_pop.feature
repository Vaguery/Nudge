Feature: code_execute_then_pop instruction
  In order to run stored :code items
  As a modeler
  I want Nudge to include instructions for moving :code to and from :exec in various ways
    
  Scenario: code_execute_then_pop should copy the top :code item to :exec
    Given I have pushed "do int_subtract" onto the :code stack
    When I execute the Nudge instruction "code_execute_then_pop"
    Then "block {do int_subtract do code_pop}" should be in position 0 of the :exec stack
    And stack :exec should have depth 1
    And "do int_subtract" should be in position 0 of the :code stack
    And stack :code should have depth 1
    
    
  Scenario: it should run the code while it's still on the :code stack
    Given I have pushed "do code_duplicate" onto the :code stack
    And I have pushed "do code_execute_then_pop" onto the :exec stack
    When I run the interpreter
    Then stack :code should have depth 1
    And "do code_duplicate" should be in position -1 of the :code stack
  
  
  