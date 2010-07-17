Feature: Code 'list' manipulation
  In order to emulate the classical LISP-like languages
  As a modeler
  I want Nudge instructions for car, cdr, cons and related methods
    
    
  Scenario: code_gsub should replace all subtrees in arg1 matching arg2 with arg3
    Given I have pushed "block {ref x ref y ref x}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    And I have pushed "do a" onto the :code stack
    When I execute the Nudge instruction "code_gsub"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a ref y do a}"
    
    
  Scenario: code_gsub should traverse subtrees in arg1
    Given I have pushed "block {ref x block {ref y block {ref x}}}" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    And I have pushed "do a" onto the :code stack
    When I execute the Nudge instruction "code_gsub"
    Then the original arguments should be gone
    And the :code stack should contain "block {do a block {ref y block {do a}}}"
    
    
  Scenario: code_gsub should not search code in footnotes
    Given I have pushed "block {value «code»} \n«code ref x" onto the :code stack
    And I have pushed "ref x" onto the :code stack
    And I have pushed "do a" onto the :code stack
    When I execute the Nudge instruction "code_gsub"
    Then the original arguments should be gone
    And the :code stack should contain "block {value «code»} \n«code ref x"
    
    
  Scenario: code_gsub should replace footnotes as appropriate
    Given I have pushed "block {value «code» value «int»} \n«code ref x \n«int» 9" onto the :code stack
    And I have pushed "value «int» \n «int» 9" onto the :code stack
    And I have pushed "do a" onto the :code stack
    When I execute the Nudge instruction "code_gsub"
    Then the original arguments should be gone
    And the :code stack should contain "block {value «code» do a} \n«code ref x"
