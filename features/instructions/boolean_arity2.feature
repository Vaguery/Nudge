Feature: Boolean arity-2 logic instructions
  In order to describe and manipulate discrete logical variables
  As a modeler
  I want a suite of Boolean logic Nudge instructions
  
  Scenario: basic arity-2 instructions
    Given I have placed "<arg1>" and "<arg2>" on the :bool stack
    And arg2 is on top of the :bool stack
    When I execute the Nudge code "<instruction>"
    Then "<result>" should be on top of the :bool stack
    And neither of the arguments should be left there
    
    Scenario Outline: bool_and
      | arg1  | arg2  | instruction | result  |
      | true  | true  | do bool_and | true    |
      | true  | false | do bool_and | false   |
      | false | true  | do bool_and | false   |
      | false | false | do bool_and | false   |
      
      
    Scenario Outline: bool_or
      | arg1  | arg2  | instruction | result  |
      | true  | true  | do bool_or  | true    |
      | true  | false | do bool_or  | true    |
      | false | true  | do bool_or  | true    |
      | false | false | do bool_or  | false   |
      
      
    Scenario Outline: bool_xor
      | arg1  | arg2  | instruction | result  |
      | true  | true  | do bool_xor | false   |
      | true  | false | do bool_xor | true    |
      | false | true  | do bool_xor | true    |
      | false | false | do bool_xor | false   |
    