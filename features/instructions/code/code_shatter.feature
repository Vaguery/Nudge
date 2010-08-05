Feature: code_shatter instruction
  In order to manipulate Nudge blocks as if they were Arrays
  As a programmer
  I want a Nudge instruction that act like Ruby's Array.flatten method
    
  Scenario: code_shatter(1) should push all the elements of a simple block onto the :code stack
    Given I have pushed "block {do a do b}" onto the :code stack
    And I have pushed "1" onto the :int stack
    When I execute the Nudge instruction "code_shatter"
    Then "do a" should be in position -2 of the :code stack
    And "do b" should be in position -1 of the :code stack
    And that stack's depth should be 2
    
    
  Scenario: code_shatter(0) should leave a simple block alone
    Given I have pushed "block {do a do b}" onto the :code stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "code_shatter"
    Then "block {do a do b}" should be in position -1 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_shatter(9) should push all the elements of a simple block onto the :code stack
    Given I have pushed "block {do a do b}" onto the :code stack
    And I have pushed "9" onto the :int stack
    When I execute the Nudge instruction "code_shatter"
    Then "do a" should be in position -2 of the :code stack
    And "do b" should be in position -1 of the :code stack
    And that stack's depth should be 2
        
    
  Scenario: code_shatter(negative) should leave a the argument alone
    Given I have pushed "block {block {do a} block {do b do c}}" onto the :code stack
    And I have pushed "-9912" onto the :int stack
    When I execute the Nudge instruction "code_shatter"
    Then "block {block {do a} block {do b do c}}" should be in position -1 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_shatter applied to a non-block should leave a the argument alone
    Given I have pushed "ref x" onto the :code stack
    And I have pushed "1" onto the :int stack
    When I execute the Nudge instruction "code_shatter"
    Then "ref x" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_shatter(1) should only unwrap one layer of a nested code block
    Given I have pushed "block {block {do a} do b}" onto the :code stack
    And I have pushed "1" onto the :int stack
    When I execute the Nudge instruction "code_shatter"
    Then "block {do a}" should be in position 0 of the :code stack
    And "do b" should be in position 1 of the :code stack
    And that stack's depth should be 2
    
    
  Scenario: code_shatter(12) should totally shatter a depth-3 tree
    Given I have pushed "block {block {block {do a}} block {do b block {do c}}}" onto the :code stack
    And I have pushed "12" onto the :int stack
    When I execute the Nudge instruction "code_shatter"
    Then "do a" should be in position -3 of the :code stack
    And "do b" should be in position -2 of the :code stack
    And "do c" should be in position -1 of the :code stack
    And that stack's depth should be 3
    
    
  Scenario: code_shatter(0) should not change depth-3 tree
    Given I have pushed "block {block {block {do a}} do b}" onto the :code stack
    And I have pushed "0" onto the :int stack
    When I execute the Nudge instruction "code_shatter"
    Then "block {block {block {do a}} do b}" should be in position -1 of the :code stack
    And that stack's depth should be 1
