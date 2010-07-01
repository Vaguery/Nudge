Feature: Conversions
  In order to manipulate values with different nominal types
  As a modeler
  I want Nudge to include instructions for converting primitive types
  
  
  Scenario Outline: basic type conversions
    Given an interpreter with a value "<arg>" on stack "<type1>"
    When I execute "<instruction>"
    Then the original argument should be gone
    And a new value "<result>" should be on stack "<type2>"
    
    
    Examples: float_from_int
    | arg | type1 | instruction    | result | type2 |
    |  12 | int   | float_from_int |  12.0  | float |
    | -12 | int   | float_from_int | -12.0  | float |
    |   0 | int   | float_from_int |   0.0  | float |
    |  -0 | int   | float_from_int |   0.0  | float |
    
    
    Examples: int_from_float
    | arg   | type1  | instruction    | result | type2 |
    |  12.0 |  float | int_from_float |  12    | int   |
    |  12.6 |  float | int_from_float |  12    | int   |
    |  12.1 |  float | int_from_float |  12    | int   |
    |  -1.2 |  float | int_from_float |  -1    | int   |
    |   0.0 |  float | int_from_float |   0    | int   |
    |  -0.0 |  float | int_from_float |   0    | int   |
    
    
    Examples: int_from_bool
    | arg   | type1  | instruction   | result | type2 |
    |  true |  bool  | int_from_bool |   1    | int   |
    | false |  bool  | int_from_bool |   0    | int   |
    
    
    Examples: bool_from_int
    | arg   | type1  | instruction   | result | type2 |
    |  102  |   int  | bool_from_int |  true  |  int  |
    | -102  |   int  | bool_from_int |  true  |  int  |
    |   0   |   int  | bool_from_int | false  |  int  |
    |  -0   |   int  | bool_from_int | false  |  int  |
    
    
    Examples: float_from_bool
    | arg   | type1  | instruction     | result | type2 |
    |  true |  bool  | float_from_bool |   1.0  | float |
    | false |  bool  | float_from_bool |   0.0  | float |
    
    
    Examples: bool_from_float
    | arg   | type1  | instruction     | result | type2 |
    |  7.1  |   int  | bool_from_float |  true  |  bool |
    | -7.1  |   int  | bool_from_float |  true  |  bool |
    |  0.0  |   int  | bool_from_float | false  |  bool |
    | -0.0  |   int  | bool_from_float | false  |  bool |
    
    
    Examples: float_from_proportion
    | arg   | type1      | instruction           | result | type2 |
    | 0.123 | proportion | float_from_proportion | 0.123  | float |
    | 0.0   | proportion | float_from_proportion |   0.0  | float |
    
    
    Examples: proportion_from_float
    | arg   | type1 | instruction           | result | type2       |
    |  7.1  | float | proportion_from_float |   0.1  |  proportion |
    | -7.2  | float | proportion_from_float |   0.2  |  proportion |
    |  0.0  | float | proportion_from_float |   0.0  |  proportion |
    | -8.0  | float | proportion_from_float |   0.0  |  proportion |
    
    
    Examples: code_from_int
    | arg   | type1 | instruction   | result                     | type2 |
    | 123   | int   | code_from_int |  "value «int» \n«int» 123" | code  |
    | -22   | int   | code_from_int |  "value «int» \n«int» -22" | code  |
    
    
    Examples: code_from_float
    | arg   | type1 | instruction     | result                            | type2 |
    | 1.231 | float | code_from_float |  "value «float» \n«float» 1.231"  | code  |
    | -.000 | float | code_from_float |  "value «float» \n«float» -0.000" | code  |
    
    
    Examples: code_from_name
    | arg   | type1 | instruction    | result    | type2 |
    | x1    |  name | code_from_name |  "ref x1" | code  |
    
    