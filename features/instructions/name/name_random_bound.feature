Feature: name_random_bound instruction
  In order to refer to variables that may not be strictly ordered
  As a modeler
  I want to be able to select a bound name at random
    
Scenario: selects one of the bound variables
  Given I have bound "x" to an :int with value "9"
  When I execute the Nudge instruction "name_random_bound"
  Then "x" should be in position -1 of the :name stack
  

# http://en.wikipedia.org/wiki/Checking_whether_a_coin_is_fair
Scenario: selects from the bound variables with uniform probability
  Given I have bound "x" to an :int with value "9"
  And I have bound "y" to an :int with value "9"
  And I have bound "z" to an :int with value "9"
  And I have pushed "block {value «int» do exec_do_count do name_random_bound}\n«int»20000" onto the :exec stack
  And I have set the Interpreter's termination point_limit to 1000000
  And I have set the Interpreter's termination time_limit to 5
  When I run the interpreter
  Then stack :name should have depth 20000
  And the proportion of "y" on the :name stack should fall between 0.32 and 0.34


Scenario: if nothing is bound, returns no result or error
  When I execute the Nudge instruction "name_random_bound"
  Then stack :name should have depth 0
  And stack :error should have depth 0
  

# Scenario: if a variable has been bound but is somehow unbound, it should not be selected
