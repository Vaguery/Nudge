Feature: float_divmod instruction
  In order to save some trouble and kill two birds with one stone
  As a modeler
  I want a Nudge divmod instruction that returns both results from the Knuth algorithm
  
  Scenario Outline: 
    Given I have pushed "<arg1>" onto the :float stack
    And I have pushed "<arg2>" onto the :float stack
    When I execute the Nudge instruction "float_divmod"
    Then something close to "<q>" should be in position -2 of the :float stack
    And something close to "<r>" should be in position -1 of the :float stack
    And stack :float should have depth <depth>
    And the top :error should include "<error>"

      
      
    Examples: float_divmod uses Knuth divmod algorithm
      | arg1 | arg2 | q    | r    | depth | error |
      | 9.0  | 3.0  | 3.0  | 0.0  | 2     |       |
      | 9.0  | -3.0 | -3.0 | 0.0  | 2     |       |
      | -9.0 | 3.0  | -3.0 | 0.0  | 2     |       |
      | -9.0 | -3.0 | 3.0  | 0.0  | 2     |       |
      | -9.0 | 3.1  | -3.0 | 0.3  | 2     |       |
      | -9.0 | -3.1 | 2.0  | -2.8 | 2     |       |
      
    Examples: edge cases
      | arg1 | arg2 | q    | r   | depth | error |
      | 3.0  | 3.0  | 1.0  | 0.0 | 2     |       |
      | -3.0 | 3.0  | -1.0 | 0.0 | 2     |       |
      
      
    Examples: float_divmod emits an :error for dividing by 0
      | arg1 | arg2 | r | r | depth | error                                        |
      | 3.0  | 0.0  |   |   | 0     | DivisionByZero: cannot divide a float by 0.0 |
      | 0.0  | 0.0  |   |   | 0     | DivisionByZero: cannot divide a float by 0.0 |
      | 0.0  | -0.0 |   |   | 0     | DivisionByZero: cannot divide a float by 0.0 |
