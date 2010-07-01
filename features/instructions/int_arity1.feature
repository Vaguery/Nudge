Feature: Integer arity-1 instructions
  In order to describe and manipulate integer variables
  As a modeler
  I want a suite of Integer arithmetic Nudge instructions
  
  Scenario Outline: basic arity-1 instructions
    Given I have placed "<arg1>" on the :int stack
    When I execute the Nudge code "<instruction>"
    Then "<result>" should be on top of the :int stack
    And the argument should not be there
    
    Examples: int_abs
      | arg1  | instruction   | result |
      |  13   | do int_abs    |  13    |
      | -13   | do int_abs    |  13    |
      |   0   | do int_abs    |   0    |
      |  -0   | do int_abs    |   0    |
      
      
    Examples: int_negative
      | arg1 | instruction     | result | error_msg |
      |  3   | do int_negative | -3     | |
      | -4   | do int_negative |  4     | |
      |  0   | do int_negative |  0     | |
      | -0   | do int_negative |  0     | |
      
