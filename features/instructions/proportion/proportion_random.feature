Feature: Proportion random
  In order to sample continuous random variables and simulate noise
  As a modeler
  I want a proportion_random instruction

  Scenario: should return a :proportion
    When I execute the Nudge instruction "proportion_random"
    Then stack :proportion should have depth 1 
        
    
  Scenario: should produce values from [0.0,1.0)
    Given I have pushed "block {value «int» do exec_do_count do proportion_random}\n«int»100" onto the :exec stack
    When I run the interpreter
    Then stack :proportion should not contain a value less than 0.0
    And stack :proportion should not contain a value greater than 1.0
    
    
  # http://en.wikipedia.org/wiki/Checking_whether_a_coin_is_fair
  Scenario: should return a random value with equal probability 
    Given I have pushed "block {value «int» do exec_do_count do proportion_random}\n«int»20000" onto the :exec stack
    And I have set the Interpreter's termination point_limit to 1000000
    And I have set the Interpreter's termination time_limit to 5
    When I run the interpreter
    Then stack :proportion should have depth 20000
    And the proportion of values less than 0.25 on the :proportion stack should fall between 0.24 and 0.26
