Feature: bool_and instruction
  In order to describe and manipulate discrete logical variables
  As a modeler
  I want a suite of Boolean logic Nudge instructions
  
  Scenario Outline: basic arity-2 instructions
    Given I have pushed "<arg1>" onto the :bool stack
    And I have pushed "<arg2>" onto the :bool stack
    When I execute the Nudge instruction "<instruction>"
    Then "<result>" should be in position -1 of the :bool stack
    And stack :bool should have depth 1
    
    Examples: bool_and
      | arg1  | arg2  | instruction | result | 
      | true  | true  | bool_and    | true   | 
      | true  | false | bool_and    | false  | 
      | false | true  | bool_and    | false  | 
      | false | false | bool_and    | false  | 
