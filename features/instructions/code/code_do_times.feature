#encoding: utf-8

Feature: code_do_times
  In order to create iteration and recursion
  As a modeler
  I want Nudge to include the Push3 code and exec iteration instructions
    
  Scenario: code_do_times should execute the top :code item for each integer between n1 and n2
    Given I have pushed "block {ref qqq}" onto the :code stack
    And I have pushed "-3" onto the :int stack
    And I have pushed "3" onto the :int stack
    When I execute the Nudge instruction "code_do_times"
    Then "block {ref qqq}" should be in position -1 of the :exec stack
    And "block { value «int» value «int» do exec_do_times block {ref qqq}}\n«int» -2\n«int» 3" should be in position -2 of the :exec stack
    And stack :code should have depth 0
    And stack :int should have depth 0
    
    
  Scenario: code_do_times should execute the top :code item the right number of times
    Given I have pushed "block {ref qqq}" onto the :code stack
    And I have pushed "do code_do_times" onto the :exec stack
    And I have pushed "-3" onto the :int stack
    And I have pushed "3" onto the :int stack
    When I run the interpreter
    Then stack :code should have depth 0
    And stack :int should have depth 0
    And stack :name should have depth 7
    And "qqq" should be in position -7 of the :name stack
    And "qqq" should be in position -1 of the :name stack
    
    
  Scenario: code_do_times should work fine with reversed indices
    Given I have pushed "block {ref a}" onto the :code stack
    And I have pushed "-4" onto the :int stack
    And I have pushed "-21" onto the :int stack
    When I execute the Nudge instruction "code_do_times"
    Then "block {ref a}" should be in position -1 of the :exec stack
    Then "block { value «int» value «int» do exec_do_times block {ref a}}\n«int» -5\n«int» -21" should be in position -2 of the :exec stack
    And stack :code should have depth 0
    And stack :int should have depth 0
    
    
  Scenario: code_do_times should not build its macro when the indices are identical
    Given I have pushed "block {ref a}" onto the :code stack
    And I have pushed "222" onto the :int stack
    And I have pushed "222" onto the :int stack
    When I execute the Nudge instruction "code_do_times"
    Then "block {ref a}" should be in position -1 of the :exec stack
    And stack :code should have depth 0
    And stack :int should have depth 0
    
    
  Scenario: code_do_times doesn't push its counter value to :int
    Given I have pushed "block {ref a}" onto the :code stack
    And I have pushed "222" onto the :int stack
    And I have pushed "222" onto the :int stack
    When I execute the Nudge instruction "code_do_times"
    Then stack :int should have depth 0
    
    
    Scenario: the item that's copied into the loop macro should be a different object from the item above it
        Given context
        When event
        Then outcome
    