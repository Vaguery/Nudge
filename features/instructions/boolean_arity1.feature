Feature: Boolean arity-1 logic instructions
  In order to describe and manipulate discrete logical variables
  As a modeler
  I want a suite of Boolean logic Nudge instructions
  
  Scenario: basic arity-1 :bool instructions
    Given I have placed "<arg1>" on the "<stack>" stack
    When I execute the Nudge instruction "<instruction_name>"
    Then "<result>" should be on top of the "<result_stack>" stack
    And the argument should be gone
    
    Scenario Outline: bool_not
      | arg1  | stack | instruction_name | result | result_stack |
      | true  | bool  | bool_not         | false  | bool         |
      | false | bool  | bool_not         | true   | bool         |
