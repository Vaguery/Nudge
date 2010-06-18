Feature: Variables vs names
  In order to pass values into the model
  As a modeler
  I want to work with immutable 'external' variables
  And mutable 'local' names
  
  
  Scenario: variable always trumps identical name
    Given I have bound a value to a variable called "x"
    And I have also registered a name called "x"
    When I execute the Nudge line 'ref x'
    Then the variable should be returned
    