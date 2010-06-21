Feature: Name instructions
  In order to construct programs that use references
  As a modeler
  I want Nudge instructions that manipulate :name program points
  
  
  Scenario: name_disable_lookup instruction
    Given an interpreter with the name "x1" bound to the :int "7" 
    When I execute the instruction "do name_disable_lookup"
    And I execute the line "ref x1"
    Then the name "x1" should be on top of the :name stack
    And no new :int items should be present
    
    
  Scenario: name_disable_lookup instruction lasts for one use only
    Given an interpreter with the name "x1" bound to the :int "7" 
    When I execute the instruction "do name_disable_lookup"
    And I execute the line "ref x1"
    And I execute the line "ref x1"
    Then the name "x1" should be on top of the :name stack
    And an :int item with value "7" should be on the :int stack
    
    
  Scenario: name_next instruction
    Given an interpreter which has already generated 11 'next' names
    When I execute the instruction "do name_next"
    Then the resulting name point should be "ref aaa011"
    
    
  Scenario: name_random_bound instruction
    Given an interpreter with four variables bound to values
    When I execute the instruction "do name_random_bound"
    Then the resulting name point should be one of four bound ones
    
    
  Scenario: name_random_bound instruction includes all references
    Given an interpreter with four variables bound to values
    And four names bound to values
    When I execute the instruction "do name_random_bound"
    Then the resulting name point should be one of eight bound ones
    
    
  Scenario: name_random_bound instruction when nothing is bound
    Given an interpreter with no variables or names bound to values
    When I execute the instruction "do name_random_bound"
    Then there should be no result
    
    
  Scenario: name_random_bound instruction when one has been unbound
    Given an interpreter with a name that has no current binding
    When I execute the instruction "do name_random_bound"
    Then there should be no result
    
    
  Scenario: name_unbind instruction
    Given an interpreter with a name "x1" bound to :bool "false"
    And the name "x1" on top of the :name stack
    When I execute the instruction "do name_unbind"
    Then the name "x1" should no longer be bound to anything
    And the argument :name should be gone from that stack
    
    
  Scenario: name_unbind instruction when it's already unbound
    Given an interpreter with a pre-existing name "x1" bound to nothing
    And the name "x1" on top of the :name stack
    When I execute the instruction "do name_unbind"
    Then the name "x1" should still not be bound to anything
    And the argument :name should be gone from that stack
    
    
  Scenario: name_unbind instruction applied to a variable raises an error
    Given an interpreter with a pre-existing variable "x1"
    And the name "x1" on top of the :name stack
    When I execute the instruction "do name_unbind"
    Then an :error item should be created "attempted to name_unbind a variable"
    And the argument :name should be gone from that stack
