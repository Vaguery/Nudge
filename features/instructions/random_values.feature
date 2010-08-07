Feature: random value instructions
  In order to discover probabilistic algorithms
  As a modeler
  I want instructions that sample random values for many types
  
    
    
  Scenario: proportion_random default bounds
    Given no changes have been made to :proportion random bounds
    When I execute the Nudge instruction 'do proportion_random'
    Then a new :proportion value should be pushed
    And its value should be a uniform sample from the range [0.0,1.0]
    
    
  Scenario: proportion_random with bounds changed
    Given the :proportion random minimum bound is 0.3
    And the :proportion random maximum bound is 0.6
    When I execute the Nudge instruction 'do proportion_random'
    Then a new :proportion value should be pushed
    And its value should be a uniform sample from the range [0.3, 0.6]
    
    
  Scenario: proportion_random with bounds crossed
    Given the :proportion random minimum bound is 0.9
    And the :proportion random maximum bound is 0.3
    When I execute the Nudge instruction 'do proportion_random'
    Then a new :proportion value should be pushed
    And its value should (definitely) be 0.3
    
    
  Scenario: proportion_random with exceeded bounds
    Given the :proportion random minimum bound is -9.1
    And the :proportion random minimum bound is 0.6
    When I execute the Nudge instruction 'do proportion_random'
    Then a new :proportion value should be pushed
    And its value should be a uniform sample from the range [0.0, 0.6]
    
    
  Scenario: proportion_random with stupid bounds
    Given the :proportion random minimum bound is 111.111
    And the :proportion random maximum bound is -12.0
    When I execute the Nudge instruction 'do proportion_random'
    Then a new :proportion value should be pushed
    And its value should (definitely) be 0.0