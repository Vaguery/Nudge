Feature: Int random
  In order to sample discrete random variables
  As a modeler
  I want an int_random instruction

  Scenario: should return an :int
    When I execute the Nudge instruction "int_random"
    Then stack :int should have depth 1 
    
    
  Scenario: int_random default bounds should be [-100.0, 100.0)
    Then the interpreter's @min_int should be -100
    And the interpreter's @max_int should be 100
    
    
  Scenario: should produce all numbers from the assigned range (inclusive)
    Given I have set the Interpreter's min_int to 99
    And I have set the Interpreter's max_int to 101
    And I have pushed "block {value «int» do exec_do_count do int_random}\n«int»20" onto the :exec stack
    When I run the interpreter
    Then stack :int should include "99"
    And stack :int should include "100"
    And stack :int should include "101"
    
    
  # http://en.wikipedia.org/wiki/Checking_whether_a_coin_is_fair
  Scenario: should return a random value with equal probability 
    Given I have pushed "block {value «int» do exec_do_count do int_random}\n«int»20000" onto the :exec stack
    And I have set the Interpreter's min_int to 1
    And I have set the Interpreter's max_int to 3
    And I have set the Interpreter's termination point_limit to 1000000
    And I have set the Interpreter's termination time_limit to 5
    When I run the interpreter
    Then stack :int should have depth 20000
    And the proportion of "1" on the :int stack should fall between 0.32 and 0.34
