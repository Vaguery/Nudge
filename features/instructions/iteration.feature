#encoding: utf-8

Feature: Iteration control structures
  In order to create iteration and recursion
  As a modeler
  I want Nudge to include the Push3 code and exec instructions
    
    
    
    
    
  Scenario: exec_do_times should execute the top :exec item for each integer in [n1, n2]
    Given an interpreter with "ref bar" on the :exec stack
    And "2" on the :int stack
    And "-1" above that on the :int stack
    When I execute "do exec_do_times"
    Then a new :exec item "block { value «int» value «int» do exec_do_times ref bar}\n«int» 1\n«int» -1"
    And the arguments will have disappeared
    
    
  Scenario: exec_do_times should not build its macro when the indices are identical
    Given an interpreter with "ref bar" on the :exec stack
    And "121" on the :int stack
    And "121" above that on the :int stack
    When I execute "do exec_do_times"
    Then a new :exec item "ref bar"
    And the arguments will have disappeared
    
    
  Scenario: exec_do_times doesn't push its counter value to :int
    Given an interpreter with "block {ref x}" on the :exec stack
    And "1" on the :int stack
    When I execute "do exec_do_times"
    Then the :int stack will be empty
