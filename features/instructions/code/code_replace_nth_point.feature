Feature: Code_replace_nth_point
  So I can manipulate :code trees in complex ways
  As a modeler
  I want code_replace_nth_point to replace a particular point of one script with another
    
    
  Scenario: code_replace_nth_point should replace the nth point (0-based) of :code arg1 with :code arg2
    Given I have pushed "block {do a block {do b}}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "code_replace_nth_point"
    Then "block {do a ref x}" should be in position -1 of the :code stack
    And stack :int should have depth 0 
    
    
  Scenario: code_replace_nth_point should take n modulo the number of points in the arg1 (0-based)
    Given I have pushed "block {do a block {do b}}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    And I have pushed "31" onto the :int stack
    When I execute the Nudge instruction "code_replace_nth_point"
    Then "block {do a block {ref x}}" should be in position -1 of the :code stack
    And stack :int should have depth 0
    
    
  Scenario: code_replace_nth_point should return an :error if arg1 can't be parsed
    Given I have pushed "kjkdksjfdasdf" onto the :code stack
    And I have pushed "ref g" onto the :code stack
    And I have pushed "12" onto the :int stack
    When I execute the Nudge instruction "code_replace_nth_point"
    Then stack :code should have depth 0
    And stack :int should have depth 0
    Then the top :error should include "InvalidScript"


  Scenario: code_replace_nth_point should return an :error if arg1 can't be parsed
    Given I have pushed "ref t" onto the :code stack
    And I have pushed "reasdasdaf g" onto the :code stack
    And I have pushed "12" onto the :int stack
    When I execute the Nudge instruction "code_replace_nth_point"
    Then stack :code should have depth 0
    And stack :int should have depth 0
    Then the top :error should include "InvalidScript"
