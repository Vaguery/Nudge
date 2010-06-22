Feature: Random code generation
  In order to generate samples for algorithm search
  As a modeler
  I want a flexible suite of random code generating methods
  
  
  Scenario: it should be possible to specify the exact number of points created
    Given a target size in points for code
    When I create random code
    And pass in an optional parameter specifying the desired points
    Then the result should have exactly that many points
  
  
  Scenario: it should be possible to specify the maximum tree depth
    Given a maximum tree depth 12
    When I create random code
    And pass in an optional parameter specifying that depth
    Then the result should not have more than that depth
    
    
  Scenario: it should be possible to specify a subset of instructions to use
    Given a list [:int_add, :bool_and, :foo_bar]
    When I create random code
    And pass in the list as an optional parameter
    Then the only instructions that should appear are those three
    
    
  Scenario: the default instruction set should be all those active in the Interpreter
    Given an interpreter with only the :int_add instruction active
    But no other instructions are active
    When I create random code
    Then the only instructions that appear are :int_add
    
    
  Scenario: it should be possible to specify a set of references to use
    Given a list ["x1", "x2", "x3"] of references
    When I create random code
    And pass in the list as an optional parameter
    Then the only references that appear are those three
    
    
  Scenario: the default set of references should be those active in the Interpreter
    Given an interpreter with variables ["x1", "x2"] active
    And names ["n1", "n2"] active
    When I create random code
    Then the only references that appear are those four
    
    
  Scenario: it should be possible to specify a set of NudgeTypes to use
    Given a list [:int, :bool, :proportion]
    When I create random code
    And pass in the list as an optional parameter
    Then the only values that appear should be taken from that list
    
    
  Scenario: the default set of types should be those active in the Interpreter
    Given an interpreter with [IntType, FloatType] active
    When I create random code
    Then the only value points created should be :int and :float points
    
    
  Scenario: the default ranges for all value points are defined by the Interpreter
    Given an interpreter with the minimum random integer limit = -100
    And maximum random integer limit = 100
    And minimum random float limit = -1000.0
    And maximum random float limit = 1000.0
    And boolean bias = 0.5
    And random code size in points = 20
    When I generate random code
    Then all values should be generated using those parameters
    
    
  Scenario: it should be possible to override the range for random value generation
    Given a set of new ranges and control parameters used by various NudgeType methods
    When I create random code
    And pass in those parameters to the call
    Then the code should use those parameters
    And not use the defaults
    
    
  Scenario: it should be possible to specify the proportion of program points that are refs
    Given a Hash {refs: 0, instructions: 100, values: 200, blocks: 100}
    When I create random code
    And pass in the Hash as an optional parameter
    Then the resulting random code should have no ref points
    And 25% instruction points
    And 50% value points
    And 25% block points
    
    
