Feature: Bool random
  In order to flip coins
  As a modeler
  I want a bool_random instruction that generates true/false with equal probability
  
  
  Scenario: should return a :bool
    When I execute the Nudge instruction "bool_random"
    Then stack :bool should have depth 1 
    
  
  # http://en.wikipedia.org/wiki/Checking_whether_a_coin_is_fair
  Scenario: should return a random value with equal probability 
    Given I have pushed "block {value «int» do exec_do_count do bool_random}\n«int»20000" onto the :exec stack
    And I have set the Interpreter's termination point_limit to 1000000
    And I have set the Interpreter's termination time_limit to 5
    When I run the interpreter
    Then stack :bool should have depth 20000
    And the proportion of "false" on the :bool stack should fall between 0.49 and 0.51
