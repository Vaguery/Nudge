Feature: code_flatten instruction
  In order to manipulate Nudge blocks as if they were Arrays
  As a programmer
  I want a Nudge instruction that act like Ruby's Array.flatten method
    
  Scenario: code_flatten(1) should leave a simple block :code argument untouched
    Given I have pushed "block {do a do b}" onto the :code stack
    And I have pushed "1" onto the :int stack
    When I execute the Nudge instruction "code_flatten"
    Then "block {do a do b}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_flatten(*) should leave any non-block :code argument untouched, for any :int
    Given I have pushed "ref x" onto the :code stack
    And I have pushed "3" onto the :int stack
    When I execute the Nudge instruction "code_flatten"
    Then "ref x" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_flatten(333) should flatten any backbone elements of a block argument with treedepth < 333
    Given I have pushed "block {block {do a block {do b}} do c}" onto the :code stack
    And I have pushed "333" onto the :int stack
    When I execute the Nudge instruction "code_flatten"
    Then "block {do a do b do c}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_flatten(negative) should leave the argument alone
    Given I have pushed "block {block {do a} block {do b do c}}" onto the :code stack
    And I have pushed "-1" onto the :int stack
    When I execute the Nudge instruction "code_flatten"
    Then "block {block {do a} block {do b do c}}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
    
  Scenario: code_flatten(1) should only flatten the first inner layer from a nested block
    Given I have pushed "block {block {do a} block {block {do b} do c}}" onto the :code stack
    And I have pushed "1" onto the :int stack
    When I execute the Nudge instruction "code_flatten"
    Then "block {do a block {do b} do c}" should be in position 0 of the :code stack
    And that stack's depth should be 1
    
