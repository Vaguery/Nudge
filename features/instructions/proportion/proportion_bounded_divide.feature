Feature: proportion_bounded_divide instruction
  In order to describe and manipulate proportional quantities and probabilities
  As a modeler
  I want a suite of :proportion Nudge arithmetic instructions
  
  Scenario Outline: proportion_bounded_divide
    Given I have pushed "<arg1>" onto the :proportion stack
    And I have pushed "<arg2>" onto the :proportion stack
    When I execute the Nudge instruction "<instruction>"
    Then something close to "<result>" should be in position -1 of the :proportion stack
    And "<error_msg>" should be in position -1 of the :error stack


  Examples: proportion_bounded_divide
    | arg1 | arg2 | instruction               | result | error_msg |
    | 0.6  | 0.2  | proportion_bounded_divide | 1.0    |           |
    | 0.2  | 0.4  | proportion_bounded_divide | 0.5    |           |
    | 0.0  | 0.4  | proportion_bounded_divide | 0.0    |           |
  
  
  Examples: proportion_bounded_divide emits an error on Div0
  | arg1 | arg2 | instruction               | result | error_msg                                          |
  | 0.3  | 0.0  | proportion_bounded_divide |        | DivisionByZero: cannot divide a proportion by zero |
  | 0.0  | 0.0  | proportion_bounded_divide |        | DivisionByZero: cannot divide a proportion by zero |
