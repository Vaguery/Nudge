Feature: parser recognizes Nudge language code
  In order to hand-edit Nudge language files
  As a problem-solver
  I want to parse text files into object code in memory
  
  Scenario: one-line code
    Given a one-line Nudge program
    When I parse it
    Then I should get a single-node program tree