#encoding: utf-8

Feature: Iteration control structures
  In order to create iteration and recursion
  As a modeler
  I want Nudge to include the Push3 code and exec instructions
    
    
    
    
    
  Scenario: code_do_times should execute the top :code item for each integer between n1 and n2
    Given an interpreter with "block {ref z}" on the :code stack
    And "3" on the :int stack
    And "-3" above that on the :int stack
    When I execute "do code_do_times"
    Then a new :exec item "block { value «int» value «int» do exec_do_times block {ref z}}\n«int» 2\n«int» -3"
    And the arguments will have disappeared
    
    
  Scenario: code_do_times should not build its macro when the indices are identical
    Given an interpreter with "block {ref z}" on the :code stack
    And "6" on the :int stack
    And "6" above that on the :int stack
    When I execute "do code_do_times"
    Then a new :exec item "block {ref z}"
    And the arguments will have disappeared
    
    
  Scenario: code_do_times doesn't push its counter value to :int
    Given an interpreter with "block {ref x}" on the :code stack
    And "1" on the :int stack
    When I execute "do code_do_times"
    Then the :int stack will be empty
    
    
    
    
    
    
    
  Scenario: exec_do_count should build a macro that will execute the :exec item n times
    Given an interpreter with "do bool_and" on the :exec stack
    And "4" on the :int stack
    When I execute "do exec_do_count"
    Then a new :exec item "block { value «int» do exec_do_count do bool_and}\n«int» 3"
    And the arguments will have disappeared
    
    
  Scenario: exec_do_count stops building its macro when n==1
    Given an interpreter with "do bool_and" on the :exec stack
    And "1" on the :int stack
    When I execute "do exec_do_count"
    Then I'll see one :exec item "do bool_and"
    And the arguments will have disappeared
    
    
  Scenario: exec_do_count throws away the code for a 0 count
    Given an interpreter with "do bool_and" on the :exec stack
    And "0" on the :int stack
    When I execute "do exec_do_count"
    Then the arguments will have disappeared
    
    
  Scenario: exec_do_count creates an :error for a negative count
    Given an interpreter with "ref foo" on the :exec stack
    And "-9" on the :int stack
    When I execute "do exec_do_count"
    Then a new :error item "exec_do_count called with a negative count"
    And the arguments will have disappeared
    
    
  Scenario: exec_do_count does not push a counter value
    Given an interpreter with "ref bar" on the :exec stack
    And "1" on the :int stack
    When I execute "do exec_do_count"
    Then the :int stack will be empty
    
    
    
    
    
    
  Scenario: exec_do_range should execute the top :exec item for each integer in [n1, n2]
    Given an interpreter with "do foo" on the :exec stack
    And "9" on the :int stack
    And "11" above that on the :int stack
    When I execute "do exec_do_range"
    Then a new :exec item "block { value «int» value «int» do exec_do_range do foo}\n«int» 10\n«int» 11"
    And the arguments will have disappeared
    And the value "9" will have appeared on the :int stack
    
    
  Scenario: exec_do_range should work fine with reversed indices
    Given an interpreter with "do foo" on the :exec stack
    And "-4" on the :int stack
    And "-7" above that on the :int stack
    When I execute "do exec_do_range"
    Then a new :exec item "block { value «int» value «int» do exec_do_range do foo}\n«int» -5\n«int» -7"
    And the arguments will have disappeared
    And the value "-4" will have appeared on the :int stack
    
    
  Scenario: exec_do_range should just replicate the code arg when the indices are identical
    Given an interpreter with "do foo" on the :exec stack
    And "2" on the :int stack
    And "2" above that on the :int stack
    When I execute "do exec_do_range"
    Then I'll see a new :exec item "do foo"
    And the arguments will have disappeared
    And the value "2" will have appeared on the :int stack
    
    
  Scenario: exec_do_range pushes its counter value to :int
    Given an interpreter with "ref ggg" on the :exec stack
    And "1" on the :int stack
    When I execute "do exec_do_range"
    Then the :int stack will contain "1"
    
    
    
    
    
    
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
