Feature: code_points instruction
  In order to build models that respond to structural differences in :code objects
  As a modeler
  I want Nudge instructions that compare and measure program structures
    
    
  Scenario: code_points should return the number of points in a block item
    Given I have pushed "block {do a ref x ref x}" onto the :code stack
    When I execute the Nudge instruction "code_points"
    Then "4" should be in position 0 of the :int stack
    And stack :code should have depth 0
  
  
  Scenario: code_points should return the number of points in a reference item
    Given I have pushed "ref g" onto the :code stack
    When I execute the Nudge instruction "code_points"
    Then "1" should be in position 0 of the :int stack
    And stack :code should have depth 0
    
    
  Scenario: code_points should return the number of points in an instruction item 
    Given I have pushed "do int_add" onto the :code stack
    When I execute the Nudge instruction "code_points"
    Then "1" should be in position 0 of the :int stack
    And stack :code should have depth 0
    
    
  Scenario: code_points should return the number of points in a value item
    Given I have pushed "value «float»\n«float» 1.1" onto the :code stack
    When I execute the Nudge instruction "code_points"
    Then "1" should be in position 0 of the :int stack
    And stack :code should have depth 0
    
    
  Scenario: code_points should return 0 for unparseable code
    Given I have pushed "you're a mean one mister grinch" onto the :code stack
    When I execute the Nudge instruction "code_points"
    Then "0" should be in position 0 of the :int stack
    And stack :code should have depth 0