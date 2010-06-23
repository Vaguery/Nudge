#encoding: utf-8
Feature: Footnotes
  In order to handle arbitrary (and nested) literal values
  As a modeler
  I want Nudge to keep literal values in footnotes, not in-line in the script

  
  Scenario: footnotes must be indicated by guillemet-wrapped string at start of line
    Given a script "value «int» \n «int» 9"
    When I try to parse it
    Then it cannot be parsed  
  #   
  #   
  # Scenario: footnotes should be reassociated with value points in the code section, by type
  #   Given a program "block {value «int» value «float»}\n«int» 7 \n«float» 1.1"
  #   When I ask for a list of every program point
  #   Then point 1 should be the entire script
  #   And point 2 should be "value «int» \n«int» 7"
  #   And point 3 should be "value «float» \n«float» 1.1"
  #   
  #   
  # Scenario: footnotes are reassociated in order of appearance, by type
  #   Given a program "block {value «int» value «float» value «bool» value «int»}\n«float» 1.1 \n«bool» false \n«int» 88 \n«int» -2"
  #   When I ask for a list of every program point
  #   Then point 2 should be "value «int» \n«int» 88"
  #   And point 3 should be "value «float» \n«float» 1.1"
  #   And point 4 should be "value «bool» \n«bool» false"
  #   And point 5 should be "value «int» \n«int» -2"
  # 
  # 
  # Scenario: once a script has been parsed, the footnotes should be listed in depth-first order
  #   Given a program "block {value «int» value «float» value «bool» value «int»}\n«float» 1.1 \n«bool» false \n«int» 88 \n«int» -2"
  #   When I parse it
  #   And print it out again
  #   Then the script should be "block {value «int» value «float» value «bool» value «int»} \n«int» 88 \n«float» 1.1 \n«bool» false \n«int» -2"
  #   
  # 
  # Scenario: extra footnotes should be thrown away after parsing
  #   Given a program "value «int» \n«int» 8 \n«int» 99"
  #   When I parse it
  #   And print it out again
  #   Then the script should be "value «int» \n«int» 8"
  #   
  #   
  # Scenario: scripts with missing footnotes can be parsed
  #   Given a script "block { value «int»}"
  #   When I parse it
  #   And ask for a list of every program point
  #   Then point 2 should be "value «int» \n«int»"
  # 
  # 
  # Scenario: scripts with footnotes that lack a value string can be parsed
  #   Given a script "block { value «int»} \n«int»"
  #   When I parse it
  #   And ask for a list of every program point
  #   Then point 2 should be "value «int» \n«int»"
  # 
  # 
  # Scenario: no validation of footnote text occurs
  #   Given a script "value «int» \n«int» 9.12"
  #   When I parse it
  #   Then the value string associated with the :int will be "9.12"
  # 
  # 
  
  
  