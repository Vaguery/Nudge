Feature: Float random
  In order to sample continuous random variables and simulate noise
  As a modeler
  I want a float_random instruction

  Scenario: should return a :float
    When I execute the Nudge instruction "float_random"
    Then stack :float should have depth 1 
    
    
  Scenario: float_random default bounds should be [-100.0, 100.0)
    Then the interpreter's @min_float should be -100.0
    And the interpreter's @max_float should be 100.0
    
    
  Scenario: should produce floats from the assigned range
    Given I have set the Interpreter's min_float to 11.0
    And I have set the Interpreter's max_float to 11.1
    And I have pushed "block {value «int» do exec_do_count do float_random}\n«int»100" onto the :exec stack
    When I run the interpreter
    Then stack :float should not contain a value less than 11.0
    And stack :float should not contain a value greater than 11.1
    
    
    
  # http://en.wikipedia.org/wiki/Checking_whether_a_coin_is_fair
  Scenario: should return a random value with equal probability 
    Given I have pushed "block {value «int» do exec_do_count do float_random}\n«int»20000" onto the :exec stack
    And I have set the Interpreter's min_float to 0.0
    And I have set the Interpreter's max_float to 4.0
    And I have set the Interpreter's termination point_limit to 1000000
    And I have set the Interpreter's termination time_limit to 5
    When I run the interpreter
    Then stack :float should have depth 20000
    And the proportion of values less than 1.0 on the :float stack should fall between 0.24 and 0.26
