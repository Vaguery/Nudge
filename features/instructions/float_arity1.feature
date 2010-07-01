Feature: Float arity-1 math instructions
  In order to describe and manipulate machine-precision numerical variables
  As a modeler
  I want a suite of :float Nudge arithmetic instructions
  
  Scenario Outline: basic arity-1 instructions
    Given I have placed "<arg1>" on the :float stack
    When I execute the Nudge code "<instruction>"
    Then a value very close to "<result>" should be on top of the :float stack
    And a message "<error_msg>" should be on the :error stack
    And the argument should not remain on :float
    
    Examples: float_abs
      | arg1  | instruction  | result | error_msg |
      |  11.1 | do float_abs | 11.1   | |
      | -12.0 | do float_abs | 12.0   | |
      |   0.0 | do float_abs | 0.0    | |
      |  -0.0 | do float_abs | 0.0    | |
      
      
    Examples: float_negative
      | arg1  | instruction       | result | error_msg |
      |  3.3  | do float_negative | -3.3   | |
      | -4.4  | do float_negative |  4.4   | |
      |  0.0  | do float_negative |  0.0   | |
      | -0.0  | do float_negative |  0.0   | |
      
      
    Examples: float_sqrt
      | arg1  | instruction   | result | error_msg |
      |  64.0 | do float_sqrt | 8.0    | |
      |   0.0 | do float_sqrt | 0.0    | |
      |  -0.0 | do float_sqrt | 0.0    | |
      |   1.0 | do float_sqrt | 1.0    | |
      |  -1.0 | do float_sqrt |        | "float_sqrt(-1.0) did not return a float" |
      | -64.0 | do float_sqrt |        | "float_sqrt(-64.0) did not return a float" |