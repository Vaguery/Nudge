#encoding: utf-8
Feature: Code classification
  In order to build control structures and decisions based on :code item structure
  As a modeler
  I want Nudge instructions that classify and match :code
  
  
  Scenario: code_atom? should be true if the argument is an instruction
    Given I have pushed "do a" onto the :code stack
    When I execute the Nudge instruction "code_atom?"
    Then "true" should be in position 0 of the :bool stack
    And stack :code should have depth 0
  
  
  Scenario: code_atom? should be true if the argument is a reference
    Given I have pushed "ref a" onto the :code stack
    When I execute the Nudge instruction "code_atom?"
    Then "true" should be in position 0 of the :bool stack
    And stack :code should have depth 0
    
    
  Scenario: code_atom? should be true if the argument is value
    Given I have pushed "value «int»\n«int» 8" onto the :code stack
    When I execute the Nudge instruction "code_atom?"
    Then "true" should be in position 0 of the :bool stack
    And stack :code should have depth 0
    
    
  Scenario: code_atom? should be true if the argument is value that contains a block
    Given I have pushed "value «code»\n«code» block {}" onto the :code stack
    When I execute the Nudge instruction "code_atom?"
    Then "true" should be in position 0 of the :bool stack
    And stack :code should have depth 0
    
    
  Scenario: code_atom? should be false if the argument is a block
    Given I have pushed "block {}" onto the :code stack
    When I execute the Nudge instruction "code_atom?"
    Then "false" should be in position 0 of the :bool stack
    And stack :code should have depth 0
    
    
  Scenario: code_atom? should be false if the argument is unparseable
    Given I have pushed "i am not valid" onto the :code stack
    When I execute the Nudge instruction "code_atom?"
    Then "false" should be in position 0 of the :bool stack
    And stack :code should have depth 0
