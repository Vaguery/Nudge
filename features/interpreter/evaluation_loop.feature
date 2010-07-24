Feature: Evaluation loop
  In order to run Nudge programs
  As a modeler
  I want the interpreter to be able to handle all five basic program points
      
    
    
  Scenario: ref handling of a bound variable
    Given an interpreter with "ref x1" on :exec
    And variable "x1" is bound to :int "999"
    When I take one execution step
    Then a value point with type :int and value "999" should be on :exec
  
  
  Scenario: ref handling with a bound name
    Given an interpreter with "ref x1" on :exec
    And name "x1" is bound to :int "999"
    And no "x1" is defined in the variables list
    When I take one execution step
    Then a value point with type :int and value "999" should be on :exec
  
  
  Scenario: references use variables before names
    Given an interpreter with "ref x1" on :exec
    And variable "x1" is bound to :float "1.1"
    And name "x1" is bound to :int "999"
    When I take one execution step
    Then a value point with type :float and value "1.1" should be on :exec
  
  
  Scenario: refs with no binding
    Given an interpreter with "ref x1" on :exec
    And no variables or names are assigned
    When I take one execution step
    Then a ref point "x1" should be on the :name stack
    And nothing should be on the :exec stack
  
  
  Scenario: instruction handling when all prerequisites are met
    Given an interpreter with "do int_add" on :exec
    And two :int values on the :int stack, with values "2" and "3"
    When I take one execution step
    Then the arguments should disappear from :int
    And a new value "5" should be on :int
    And nothing should be on the :exec stack
    
    
  Scenario: instruction handling when arguments are missing
    Given an interpreter with "do int_add" on :exec
    And one :int value "4" on the :int stack
    When I take one execution step
    Then nothing should be on the :int stack
    And nothing should be on the :exec stack
    And a new :error value "int_add lacks one or more arguments"
  
  
  Scenario: instruction handling when instruction is inactive or unknown
    Given an interpreter with "do foo_bar" on :exec
    When I take one execution step
    Then nothing should be on the :exec stack
    And a new :error value "'foo_bar' is not a known instruction"
  
  
  Scenario: value handling when a stack exists
    Given an interpreter with "value «int»\n«int» 8" on the :exec stack
    And an :int stack
    When I take one execution step
    Then a new :int value "8" should appear on the :int stack
    And nothing should be on the :exec stack
    
    
  Scenario: value handling when a stack does not exist
    Given an interpreter with "value «foo» \n«foo» bar" on the :exec stack
    And no :foo stack
    When I take one execution step
    Then a new :foo stack should exist
    And it should contain a value "bar"
    
    
  Scenario: value handling when there is no footnote
    Given an interpreter with "value «missing»" on the :exec stack
    When I take one execution step
    Then nothing should be on the :exec stack
    And a new :error value "«missing» without associated value" should appear on the :error stack
    
    
  Scenario: nil point handling
    Given an interpreter with "end of line" on the :exec stack
    When I take an execution step
    Then a new :error value "cannot parse 'end of line'" should appear on the :error stack
  
  
  