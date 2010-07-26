Feature: Stack behavior
  In order to collect and order values
  As a modeler
  I want stacks to work as typical pushdown stacks
  
  Scenario: an empty stack should return no value
    Given I have pushed "do code_noop" onto the :exec stack
    When I take one execution step
    Then 
  
  
  
