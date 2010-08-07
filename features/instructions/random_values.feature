Feature: random value instructions
  In order to discover probabilistic algorithms
  As a modeler
  I want instructions that sample random values for many types
  
    
    
  Scenario: int_random default bounds
    Given no changes have been made to :int random bounds
    When I execute the Nudge instruction 'do int_random'
    Then a new :int value should be pushed
    And its value should be a uniform sample from the range [-100, 100]
    
    
  Scenario: int_random with bounds changed
    Given the :int random minimum bound is 5
    And the :int random maximum bound is 7
    When I execute the Nudge instruction 'do int_random'
    Then a new :int value should be pushed
    And its value should be a uniform sample from the range [5, 7]
    
    
  Scenario: int_random with bounds crossed
    Given the :int random minimum bound is 800
    And the :int random maximum bound is 12
    When I execute the Nudge instruction 'do int_random'
    Then a new :int value should be pushed
    And its value should (definitely) be 12
    
    
  Scenario: float_random default bounds
    Given no changes have been made to :float random bounds
    When I execute the Nudge instruction 'do float_random'
    Then a new :float value should be pushed
    And its value should be a uniform sample from the range [-1000.0, 1000.0]
    
    
  Scenario: float_random with bounds changed
    Given the :float random minimum bound is 5.0
    And the :float random maximum bound is 7.0
    When I execute the Nudge instruction 'do float_random'
    Then a new :float value should be pushed
    And its value should be a uniform sample from the range [5.0, 7.0]
    
    
  Scenario: float_random with bounds crossed
    Given the :float random minimum bound is 111.111
    And the :float random maximum bound is 8.8
    When I execute the Nudge instruction 'do float_random'
    Then a new :float value should be pushed
    And its value should (definitely) be 8.8
    
    
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