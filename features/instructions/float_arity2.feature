Feature: Float arity-2 math instructions
  In order to describe and manipulate machine-precision numerical variables
  As a modeler
  I want a suite of :float Nudge arithmetic instructions
  
  Scenario Outline: basic arity-2 instructions
    Given I have placed "<arg1>" on the :float stack
    And I have placed "<arg2>" on top of that
    When I execute the Nudge code "<instruction>"
    Then a value very close to "<result>" should be on top of the :float stack
    And a message "<error_msg>" should be on the :error stack
    And the arguments should not remain on :float

      
    Examples: float_power
      | arg1  | arg2  | instruction     | result | error_msg |
      |  0.2  |  1.0  | do float_power  |  0.2   | |
      |  0.2  |  2.0  | do float_power  |  0.04  | |
      | -0.2  |  2.0  | do float_power  |  0.04  | |
      | 12.8  |  3.1  | do float_power  |  2706.14402023331    | |
      |-12.8  |  3.1  | do float_power  |  0.0   | "float_power did not return a float" |
      |  0.2  |  0.0  | do float_power  |  1.0   | |
      | -0.2  |  0.0  | do float_power  |  1.0   | |
      |  0.2  |  0.0  | do float_power  |  1.0   | |
      | 64.0  |  0.5  | do float_power  |  8.0   | |
      |-64.0  |  0.5  | do float_power  |        | "float_power did not return a float" |
      |  0.0  |  0.0  | do float_power  |  1.0   | |
