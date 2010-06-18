Feature: Boolean arity-1 logic instructions
  In order to describe and manipulate discrete logical variables
  As a modeler
  I want a suite of Boolean logic Nudge instructions
  
  Scenario: basic arity-1 instructions
    Given I have placed "<arg1>" on the :bool stack
    When I execute the Nudge code "<instruction>"
    Then "<result>" should be on top of the :bool stack
    And the argument should not be there
    
    Scenario Outline: bool_not
      | arg1  | instruction | result |
      | true  | do bool_not | false  |
      | false | do bool_not | true   |
