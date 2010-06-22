#encoding: utf-8
Feature: instructions binding stack items to references, and looking them up
  In order to work with programs referring to values
  As a Nudge programmer
  I want a suite of _define instructions to link References to new values
  
  Scenario: binding to an unbound name
    Given I have placed a value on the :name stack
    And that reference is not bound to anything yet
    And a value is on some other stack
    When I execute the Nudge instruction [stack]_define
    Then the value should be bound to that name
    And neither of the arguments should be left on stacks
    
  Scenario: error when rebinding a variable
    Given I have placed a value on the :name stack
    And that reference is a defined variable
    And a value is on some other stack
    When I execute the Nudge instruction [stack]_define
    Then the variable should be unchanged
    And an :error 'Cannot rebind a variable' should be pushed
    And neither of the arguments should be left on stacks
    
  Scenario: rebinding a name
    Given I have placed a value on the :name stack
    And that reference is a bound name
    And a value is on some other stack
    When I execute the Nudge instruction [stack]_define
    Then the name should be changed
    And the new value should be bound to that name
    And neither of the arguments should be left on stacks
    
    
    
    
    
    
  Scenario: code_name_lookup instruction should push a new :code item based on a ref
    Given an interpreter with name "x" bound to :int "789"
    And "x" on the :name stack
    When I execute "do code_name_lookup"
    Then a new value "value «int» \n«int» 789" should be on the :code stack
    
    
  Scenario: code_name_lookup instruction should create an :error when the reference is unbound
    Given an interpreter with name "x" but no current binding
    And "x" on the :name stack
    When I execute "do code_name_lookup"
    Then I should have a new :error "code_name_lookup referenced an unbound name"
