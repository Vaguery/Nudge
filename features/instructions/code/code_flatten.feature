Feature: code_flatten instruction
  In order to manipulate Nudge blocks as if they were Arrays
  As a programmer
  I want a Nudge instruction that act like Ruby's Array.flatten method

    Scenario: code_flatten(1) should leave a simple block alone
      Given I have pushed "block {do a do b}" onto the :code stack
      And I have pushed "1" onto the :int stack
      When I execute the Nudge instruction "code_flatten"
      Then "block {do a do b}" should be in position -1 of the :code stack
      And stack :code should have depth 1
      And stack :int should have depth 0
      
      
    Scenario: code_flatten(0) should leave a simple block alone
      Given I have pushed "block {do a do b}" onto the :code stack
      And I have pushed "0" onto the :int stack
      When I execute the Nudge instruction "code_flatten"
      Then "block {do a do b}" should be in position -1 of the :code stack
      And stack :code should have depth 1
      And stack :int should have depth 0
      


    Scenario: code_flatten(negative) should leave a the argument alone
      Given I have pushed "block {block {do a} block {do b do c}}" onto the :code stack
      And I have pushed "-9912" onto the :int stack
      When I execute the Nudge instruction "code_flatten"
      Then "block {block {do a} block {do b do c}}" should be in position -1 of the :code stack
      And stack :code should have depth 1
      And stack :int should have depth 0
      


    Scenario: code_flatten applied to a non-block should leave a the argument alone
      Given I have pushed "ref x" onto the :code stack
      And I have pushed "1" onto the :int stack
      When I execute the Nudge instruction "code_flatten"
      Then "ref x" should be in position 0 of the :code stack
      And stack :code should have depth 1
      And stack :int should have depth 0
      


    Scenario: code_flatten(1) should only unwrap one layer of a nested code block
      Given I have pushed "block {block {do a} do b}" onto the :code stack
      And I have pushed "1" onto the :int stack
      When I execute the Nudge instruction "code_flatten"
      Then "block {do a do b}" should be in position -1 of the :code stack
      And stack :code should have depth 1
      And stack :int should have depth 0
      


    Scenario: code_flatten(12) should totally flatten a depth-3 tree
      Given I have pushed "block {block {block {do a}} block {do b block {do c}}}" onto the :code stack
      And I have pushed "12" onto the :int stack
      When I execute the Nudge instruction "code_flatten"
      Then "block {do a do b do c}" should be in position -1 of the :code stack
      And stack :code should have depth 1
      And stack :int should have depth 0
      
      
      
    Scenario: code_flatten(2) should somewhat flatten a depth-3 tree
      Given I have pushed "block {block {block {do a block {do b block {do c}}}}}" onto the :code stack
      And I have pushed "2" onto the :int stack
      When I execute the Nudge instruction "code_flatten"
      Then "block {do a block {do b block {do c}}}" should be in position -1 of the :code stack
      And stack :code should have depth 1
      And stack :int should have depth 0
    
      


    Scenario: code_flatten(0) should not change depth-3 tree
      Given I have pushed "block {block {block {do a}} do b}" onto the :code stack
      And I have pushed "0" onto the :int stack
      When I execute the Nudge instruction "code_flatten"
      Then "block {block {block {do a}} do b}" should be in position -1 of the :code stack
      And stack :code should have depth 1
      And stack :int should have depth 0
      
