Feature: Code_position
  In order to find nested :code blocks
  As a modeler
  I want code_position to return the 0-based index of the point in arg1 identical to arg2
    
    
  Scenario: code_position should find the first (0-based) point identical to the 2nd argument in the 1st arg 
    Given I have pushed "block {do a block {do b}}" onto the :code stack
    And I have pushed "do b" onto the :code stack
    When I execute the Nudge instruction "code_position"
    Then stack :code should have depth 0
    And "3" should be in position -1 of the :int stack
    
    
  Scenario: code_position should return an :error if the 2nd arg is not found
    Given I have pushed "block {do a block {do b}}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    When I execute the Nudge instruction "code_position"
    Then stack :code should have depth 0
    And stack :int should have depth 0
    And the top :error should include "NotFound"
    
    
  Scenario: code_position should return 0 if the two arguments are identical
    Given I have pushed "ref x" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    When I execute the Nudge instruction "code_position"
    Then stack :code should have depth 0
    And "0" should be in position -1 of the :int stack
    
    
  Scenario: code_position should return an error if arg1 can't be parsed
    Given I have pushed "00088888888" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    When I execute the Nudge instruction "code_position"
    Then stack :code should have depth 0
    And the top :error should include "InvalidScript"
    
    
  Scenario: code_position should return an error if arg2 can't be parsed
    Given I have pushed "ref g" onto the :code stack
    And I have pushed "lkasdklajnsdx" onto the :code stack
    When I execute the Nudge instruction "code_position"
    Then stack :code should have depth 0
    And the top :error should include "InvalidScript"
