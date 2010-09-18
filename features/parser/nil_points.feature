Feature: NilPoints
  In order to intelligently handle items that don't parse
  As a modeler
  I want the Nudge parser to return a NilPoint if it cannot parse code
  
  
  Scenario: NilPoint results from parsing an empty script
  Given context
  When event
  Then outcome
  
  
  Scenario: NilPoint results from parsing a script that only has footnotes
  Given context
  When event
  Then outcome
  
  
  Scenario: NilPoint results from parsing untokenized code
  Given context
  When event
  Then outcome
  
  
  Scenario: NilPoint results even from tokenized but unparseable code
  Given context
  When event
  Then outcome
  
  
  Scenario: NilPoint should have a #points attribute of 0
  Given context
  When event
  Then outcome
    
    
