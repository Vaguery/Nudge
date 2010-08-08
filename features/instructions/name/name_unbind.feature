Feature: Name unbind
  In order to manipulate values using references
  As a modeler
  I want name_unbind to unbind and delete the interpreter's record of a given name

  Scenario: when I unbind a previously bound name...
    Given I have bound "x" to a :bool with value "true"
    And I have pushed "x" onto the :name stack
    And I have pushed "ref x" onto the :exec stack
    When I execute the Nudge instruction "name_unbind"
    And I run the interpreter
    Then "x" should be in position -1 of the :name stack
  
  
  Scenario: when I unbind an already unbound name no :error should be created
    Given I have bound "x" to a :bool with value "true"
    And I have pushed "x" onto the :name stack
    And I have pushed "x" onto the :name stack
    And I have pushed "block {do name_unbind do name_unbind ref x}" onto the :exec stack
    And I run the interpreter
    Then stack :error should have depth 0 
    