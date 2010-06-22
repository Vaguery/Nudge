Feature: Variable binding
  In order to pass arguments into a Nudge script
  As a modeler
  I want to be able to specify variable bindings when setting up an interpreter
  
  
  Scenario: binding a value to a variable when running a script
    Given an interpreter
    And an :int value "9912"
    When I bind the variable "x1" to the value as an optional argument when running "ref x1"
    Then a new :int value "9912" should appear on the :int stack
  
  
  Scenario: overriding a variable binding when running a script 
    Given an interpreter with variable "x1" bound to :int "777"
    When I bind the variable "x1" to :float "1.1" as an optional argument when running "ref x1"
    Then a new :float value "1.1" should appear on the :float stack
  
  
  Scenario: binding a value to a variable in a pre-existing interpreter
    Given an interpreter with no variable bindings
    When I execute "ref x1"
    And bind the variable "x1" to :int "123"
    And execute "ref x1"
    Then a new :int "123" should be on the :int stack
    And a name "x1" should be on the :name stack
  
  
  