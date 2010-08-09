Feature: Code_delete_nth_point
  So I can manipulate :code trees in complex ways
  As a modeler
  I want code_delete_nth_point to remove a particular point of a script
    
    
  Scenario: code_delete_nth_point should remove the nth point (0-based) of its :code argument
    Given I have pushed "block {do a block {do b}}" onto the :code stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "code_delete_nth_point"
    Then "block {do a}" should be in position -1 of the :code stack
    And stack :int should have depth 0 
    
    
  Scenario: code_delete_nth_point should take n modulo the number of points in the arg (0-based)
    Given I have pushed "block {do a block {do b}}" onto the :code stack
    And I have pushed "31" onto the :int stack
    When I execute the Nudge instruction "code_delete_nth_point"
    Then "block {do a block {}}" should be in position -1 of the :code stack
    And stack :int should have depth 0
    
    
  Scenario: code_delete_nth_point should delete the code if the index (mod its length) is 0
    Given I have pushed "block {do a block {do b}}" onto the :code stack
    And I have pushed "4" onto the :int stack
    When I execute the Nudge instruction "code_delete_nth_point"
    Then stack :code should have depth 0
    And stack :int should have depth 0
    
    
  Scenario: code_delete_nth_point should return an :error if the :code item can't be parsed
    Given I have pushed "kjkdksjfdasdf" onto the :code stack
    And I have pushed "12" onto the :int stack
    When I execute the Nudge instruction "code_delete_nth_point"
    Then stack :code should have depth 0
    And stack :int should have depth 0
    Then the top :error should include "InvalidScript"