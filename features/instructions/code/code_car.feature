Feature: code_car instruction
  In order to treat Nudge blocks like LISP lists
  As a Push3 user
  I want a Nudge instruction that act like LISP's "car"
  
  
  Scenario: code_car should return the 1st element of a program with 2 or more points
    Given I have pushed "block {block {ref x} ref y ref z}" onto the :code stack
    When I execute the Nudge instruction "code_car"
    Then "block { ref x }" should be in position 0 of the :code stack
    And stack :code should have depth 1
    
    
  Scenario: code_car should return a copy of a 1-point program
    Given I have pushed "block {}" onto the :code stack
    When I execute the Nudge instruction "code_car"
    Then "block {}" should be in position 0 of the :code stack
    And stack :code should have depth 1
    
    
  Scenario: code_car should return a copy of a reference
    Given I have pushed "ref d" onto the :code stack
    When I execute the Nudge instruction "code_car"
    Then "ref d" should be in position 0 of the :code stack
    And stack :code should have depth 1
    
    
  Scenario: code_car should return a copy of an instruction
    Given I have pushed "do bool_flush" onto the :code stack
    When I execute the Nudge instruction "code_car"
    Then "do bool_flush" should be in position 0 of the :code stack
    And stack :code should have depth 1
    
    
  Scenario: code_car should return a copy of a value
    Given I have pushed "value «bool»\n«bool» false" onto the :code stack
    When I execute the Nudge instruction "code_car"
    Then "value «bool»\n«bool» false" should be in position 0 of the :code stack
    
    
  Scenario: code_car should return an error value for an unparseable program
    Given I have pushed "12345 67 8 9" onto the :code stack
    When I execute the Nudge instruction "code_car"
    Then the top :error should include "InvalidScript"
    And stack :code should have depth 0
    