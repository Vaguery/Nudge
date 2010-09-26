Feature: bool_fredkin instruction
  In order to describe and manipulate discrete logical variables in a reversible framework
  As a modeler
  I want a Fredkin Gate function
  
  Scenario Outline: Fredkin Gate
    Given I have pushed "<control_arg>" onto the :bool stack
    And I have pushed "<arg1>" onto the :bool stack
    And I have pushed "<arg2>" onto the :bool stack
    When I execute the Nudge instruction "bool_fredkin"
    Then "<control_out>" should be in position -3 of the :bool stack
    And "<out1>" should be in position -2 of the :bool stack
    And "<out2>" should be in position -1 of the :bool stack
    And stack :bool should have depth 3
    
    Examples: bool_and
      | control_arg | arg1  | arg2  | control_out | out1  | out2  |
      | true        | true  | false | true        | false | true  |
      | true        | false | true  | true        | true  | false |
      | false       | true  | false | false       | true  | false |
      | false       | false | true  | false       | false | true  |
