Feature: bool_toffoli instruction
  In order to describe and manipulate discrete logical variables in a reversible framework
  As a modeler
  I want a Toffoli Gate function
  
  Scenario Outline: Toffoli Gate
    Given I have pushed "<arg1>" onto the :bool stack
    And I have pushed "<arg2>" onto the :bool stack
    And I have pushed "<arg3>" onto the :bool stack
    When I execute the Nudge instruction "bool_toffoli"
    Then "<out1>" should be in position -3 of the :bool stack
    And "<out2>" should be in position -2 of the :bool stack
    And "<out3>" should be in position -1 of the :bool stack
    And stack :bool should have depth 3
    
    Examples: toffoli gate
      | arg1  | arg2  | arg3  | out1  | out2  | out3  |
      | false | false | false | false | false | false |
      | false | false | true  | false | false | true  |
      | false | true  | false | false | true  | false |
      | false | true  | true  | false | true  | true  |
      | true  | false | false | true  | false | false |
      | true  | false | true  | true  | false | true  |
      | true  | true  | false | true  | true  | true  |
      | true  | true  | true  | true  | true  | false |
