Feature: Code nth point
  In order to manipulate code trees
  As a modeler
  I want code_nth_point to extract a particular numbered point from any :code tree
    
    
  Scenario: code_nth_point should return the nth point of a program (0-based)
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "2" onto the :int stack
    When I execute the Nudge instruction "code_nth_point"
    Then stack :int should have depth 0
    And "do b" should be in position -1 of the :code stack
    
    
  Scenario: code_nth_point should take n modulo the number of points
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "7" onto the :int stack
    When I execute the Nudge instruction "code_nth_point"
    Then stack :int should have depth 0
    And "do c" should be in position -1 of the :code stack
    
    
  Scenario: code_nth_point should take arg2 = 0 to mean the first point
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "code_nth_point"
    Then stack :int should have depth 0
    And "block {do a do b do c}" should be in position -1 of the :code stack
    
    
  Scenario: code_nth_point should work as expected for negative arguments
    Given I have pushed "block {do a do b do c}" onto the :code stack
    And I have pushed "-1" onto the :int stack
    When I execute the Nudge instruction "code_nth_point"
    Then stack :int should have depth 0
    And "do c" should be in position -1 of the :code stack
    
    
  Scenario: code_nth_point should create an :error if the code can't be parsed
    Given I have pushed "a laurel, and hardy handshake" onto the :code stack
    And I have pushed "-1" onto the :int stack
    When I execute the Nudge instruction "code_nth_point"
    Then stack :int should have depth 0
    And stack :code should have depth 0
    Then the top :error should include "InvalidScript"
  