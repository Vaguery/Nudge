Feature: Integer arity-1 instructions
  In order to describe and manipulate integer variables
  As a modeler
  I want a suite of Integer arithmetic Nudge instructions
  
  Scenario: basic arity-1 instructions
    Given I have placed "<arg1>" on the :int stack
    When I execute the Nudge code "<instruction>"
    Then "<result>" should be on top of the :int stack
    And the argument should not be there
    
    Scenario Outline: int_abs
      | arg1  | instruction | result |
      |  13   | do int_abs    |  13  |
      | -13   | do int_abs    |  13  |
      |   0   | do int_abs    |   0  |
      |  -0   | do int_abs    |   0  |
      
