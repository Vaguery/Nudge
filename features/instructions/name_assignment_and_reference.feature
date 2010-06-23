#encoding: utf-8
Feature: instructions binding stack items to references, and looking them up
  In order to work with programs referring to values
  As a Nudge programmer
  I want a suite of _define instructions to link References to new values
  
  
  Scenario: exec_define instruction binds top :exec item to a new ref
    Given an interpreter with "do foo" on the :exec stack
    And the name "x1" on the :name stack
    And "x1" is not bound to a variable
    When I execute the instruction "do exec_define"
    Then the arguments should disappear
    And the name "x1" should be bound to a value equal to the old :exec item
    
    
  Scenario: exec_define instruction makes an :error when given a variable ref
    Given an interpreter with "do foo" on the :exec stack
    And the name "x1" on the :name stack
    And "x1" is bound to a variable
    When I execute the instruction "do exec_define"
    Then the arguments should disappear
    And an :error "attempted to exec_define a variable"
    
    
  Scenario: exec_define instruction rebinds when given a name ref
    Given an interpreter with "do foo" on the :exec stack
    And the name "x1" on the :name stack
    And "x1" is bound to the :int "8"
    When I execute the instruction "do exec_define"
    Then the arguments should disappear
    And the name "x1" should be bound to a value equal to the old :exec item
    
    
    
    
    
    
  Scenario: bool_define instruction binds top :bool item to a new ref
    Given an interpreter with "false" on the :bool stack
    And the name "x1" on the :name stack
    And "x1" is not bound to a variable
    When I execute the instruction "do bool_define"
    Then the arguments should disappear
    And the name "x1" should be bound to a :bool "false" value


  Scenario: bool_define instruction makes an :error when given a variable ref
    Given an interpreter with "true" on the :bool stack
    And the name "x1" on the :name stack
    And "x1" is bound to a variable
    When I execute the instruction "do bool_define"
    Then the arguments should disappear
    And an :error "attempted to bool_define a variable"


  Scenario: bool_define instruction rebinds when given a name ref
    Given an interpreter with "false" on the :bool stack
    And the name "x1" on the :name stack
    And "x1" is bound to the :int "8"
    When I execute the instruction "do bool_define"
    Then the arguments should disappear
    And the name "x1" should be bound to a :bool value equal to "false"
    
    
    
    
    
    
  Scenario: int_define instruction binds top :int item to a new ref
    Given an interpreter with "17271" on the :int stack
    And the name "x1" on the :name stack
    And "x1" is not bound to a variable
    When I execute the instruction "do int_define"
    Then the arguments should disappear
    And the name "x1" should be bound to a value "17271"


  Scenario: int_define instruction makes an :error when given a variable ref
    Given an interpreter with "22" on the :int stack
    And the name "x1" on the :name stack
    And "x1" is bound to a variable
    When I execute the instruction "do int_define"
    Then the arguments should disappear
    And an :error "attempted to int_define a variable"


  Scenario: int_define instruction rebinds when given a name ref
    Given an interpreter with "-192" on the :int stack
    And the name "x1" on the :name stack
    And "x1" is bound to the :float "8.1"
    When I execute the instruction "do int_define"
    Then the arguments should disappear
    And the name "x1" should be bound to an :int value equal to "-192"
    
    
    
    
    
    
  Scenario: float_define instruction binds top :float item to a new ref
    Given an interpreter with "2.2" on the :float stack
    And the name "x1" on the :name stack
    And "x1" is not bound to a variable
    When I execute the instruction "do float_define"
    Then the arguments should disappear
    And the name "x1" should be bound to a value "2.2"


  Scenario: float_define instruction makes an :error when given a variable ref
    Given an interpreter with "2.2" on the :float stack
    And the name "x1" on the :name stack
    And "x1" is bound to a variable
    When I execute the instruction "do float_define"
    Then the arguments should disappear
    And an :error "attempted to float_define a variable"


  Scenario: float_define instruction rebinds when given a name ref
    Given an interpreter with "-1.92" on the :float stack
    And the name "x1" on the :name stack
    And "x1" is bound to the :float "8.1"
    When I execute the instruction "do float_define"
    Then the arguments should disappear
    And the name "x1" should be bound to a :float value equal to "-1.92"
    
    
    
    
    
    
  Scenario: proportion_define instruction binds top :proportion item to a new ref
    Given an interpreter with "0.123" on the :proportion stack
    And the name "x1" on the :name stack
    And "x1" is not bound to a variable
    When I execute the instruction "do proportion_define"
    Then the arguments should disappear
    And the name "x1" should be bound to a value "0.123"


  Scenario: proportion_define instruction makes an :error when given a variable ref
    Given an interpreter with "0.123" on the :proportion stack
    And the name "x1" on the :name stack
    And "x1" is bound to a variable
    When I execute the instruction "do proportion_define"
    Then the arguments should disappear
    And an :error "attempted to proportion_define a variable"


  Scenario: proportion_define instruction rebinds when given a name ref
    Given an interpreter with "0.00" on the :proportion stack
    And the name "x1" on the :name stack
    And "x1" is bound to the :float "8.1"
    When I execute the instruction "do float_define"
    Then the arguments should disappear
    And the name "x1" should be bound to a :proportion value equal to "0.00"
    
    
    
    
    
    
    
  Scenario: code_define instruction binds top :code item to a new ref
    Given an interpreter with "do foo" on the :code stack
    And the name "x1" on the :name stack
    And "x1" is not bound to a variable
    When I execute the instruction "do code_define"
    Then the arguments should disappear
    And the name "x1" should be bound to a value equal to the old :code item


  Scenario: code_define instruction makes an :error when given a variable ref
    Given an interpreter with "do foo" on the :code stack
    And the name "x1" on the :name stack
    And "x1" is bound to a variable
    When I execute the instruction "do code_define"
    Then the arguments should disappear
    And an :error "attempted to code_define a variable"


  Scenario: code_define instruction rebinds when given a name ref
    Given an interpreter with "do foo" on the :code stack
    And the name "x1" on the :name stack
    And "x1" is bound to the :int "8"
    When I execute the instruction "do code_define"
    Then the arguments should disappear
    And the name "x1" should be bound to a value equal to the old :code item
    
    
    
    
    
    
    
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
