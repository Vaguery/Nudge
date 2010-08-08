Feature: int_unlimited_power
  In order to describe and manipulate integer numerical variables
  As a modeler
  I want an int_unlimited_power that takes all kinds of exponents and returns :int values
  
  Scenario Outline: basic arity-2 instructions
    Given I have pushed "<arg1>" onto the :int stack
    And I have pushed "<arg2>" onto the :int stack
    When I execute the Nudge instruction "int_unlimited_power"
    Then "<result>" should be in position -1 of the :int stack
    And no warning message should be produced
    And stack :int should have depth <depth>
    And the top :error should include "<error>"
      
      
    Examples: int_unlimited_power
    | arg1 | arg2 | result | depth | error |
    | 3    | 3    | 27     | 1     |       |
    | 3    | 1    | 3      | 1     |       |
    | 3    | 0    | 1      | 1     |       |
    | 3    | -3   | 0      | 1     |       |
    | -4   | 7    | -16384 | 1     |       |
    | -4   | -2   | 0      | 1     |       |
    | -4   | -2   | 0      | 1     |       |
      
    Examples: int_unlimited_power emits an :error for Infinity/-Infinity results
    | arg1   | arg2    | result | depth | error |
    | 77777  | 9999999 |        | 0     | NaN   |
    | -77777 | 9999999 |        | 0     | NaN   |
    
    
    Examples: int_unlimited_power emits an :error for dividing by zero results
    | arg1 | arg2 | result | depth | error          |
    | 0    | -3   |        | 0     | DivisionByZero |
    
