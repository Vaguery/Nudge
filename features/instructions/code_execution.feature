Feature: Code execution
  In order to run stored :code items
  As a modeler
  I want Nudge to include instructions for moving :code to and from :exec
  
  
  Scenario: code_execute should move the top :code item to :exec
    Given an interpreter with "do int_add" on the :code stack
    When I execute "do code_execute"
    Then "do int_add" should appear on :exec
    And the :code stack should be empty
    
    
    
    
    
    
    
  Scenario: code_execute_then_pop should copy the top :code item to :exec
    Given an interpreter with "do int_add" on the :code stack
    When I execute "do code_execute_then_pop"
    Then "block {do int_add do code_pop}" should appear on :exec
    But the :code stack should still contain "do int_add"
    
    
    
    
    
    
  Scenario: code_quote should move the top :exec item to :code
    Given an interpreter with "ref x" on the :exec stack
    When I execute "do code_quote"
    Then a new item "ref x" should be on :code
    
    
    