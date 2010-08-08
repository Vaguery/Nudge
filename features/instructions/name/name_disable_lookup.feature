Feature: Name disable lookup
  In order to handle names that may already be bound to values
  As a modeler
  I want name_disable_lookup to temporarily turn off the Interpreter's immediate evaluation of bound names


  Scenario: when I run the instruction, the next name will not be looked up
    Given I have bound "x" to an :int with value "123"
    And I have pushed "ref x" onto the :exec stack
    When I execute the Nudge instruction "name_disable_lookup"
    And I run the interpreter
    Then "x" should be in position -1 of the :name stack
  
  
  Scenario: the disabling only lasts until one name has been touched
    Given I have bound "x" to an :int with value "123"
    And I have pushed "block {ref x ref x}" onto the :exec stack
    When I execute the Nudge instruction "name_disable_lookup"
    And I run the interpreter
    Then "x" should be in position -1 of the :name stack
    And "123" should be in position -1 of the :int stack
  
  
  Scenario: the disabling is not toggling or cumulative, it's temporary disabling
    Given I have bound "x" to an :int with value "123"
    And I have pushed "block {ref x ref x}" onto the :exec stack
    When I execute the Nudge instruction "name_disable_lookup"
    And I execute the Nudge instruction "name_disable_lookup"
    #again
    And I run the interpreter
    Then "x" should be in position -1 of the :name stack
    And "123" should be in position -1 of the :int stack

