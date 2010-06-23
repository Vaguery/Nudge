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
    
    
  Scenario: x_define should create a new name if no variable is defined
    Given an interpreter with no variable "x1"
    And a value "99" on the :int stack
    And a value "x1" on the :name stack
    When I execute "do int_define"
    Then a new name "x1" should be bound to :int "99"
    And no variable should be defined
  
  
  