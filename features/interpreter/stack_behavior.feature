Feature: Stack behavior
  In order to manipulate values
  As a modeler
  I want the stacks to work like familiar push-down stacks


Scenario: pushing
  Given I have pushed "block {ref a ref b ref c}" onto the :exec stack
  And I have pushed "ref g" onto the :exec stack
  Then stack :exec should have depth 2
  And "ref g" should be in position -1 of the :exec stack
  And "block {ref a ref b ref c}" should be in position -2 of the :exec stack


Scenario: running pops the top item from :exec
  Given I have pushed "block {ref a ref b ref c}" onto the :exec stack
  And I have pushed "ref g" onto the :exec stack
  When I take one execution step
  Then stack :exec should have depth 1
  And "g" should be in position -1 of the :name stack
  And "block {ref a ref b ref c}" should be in position -1 of the :exec stack


Scenario: popping from a standard stack returns nil
  Then "" should be in position -1 of the :name stack
  And "" should be in position -1 of the :int stack


