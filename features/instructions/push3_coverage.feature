Feature: Push3 coverage
  In order to reproduce existing standard implementations of Push
  As a genetic programmer
  I want all the instructions from Push3 in Nudge

  Scenario Outline: they're all acceptably re-implemented
    Given a Nudge interpreter with all Push3 instructions
    When I run a program containing "<instruction>"
    Then the interpreter should recognize it
    And there should be a feature that checks its behavior
    
    
    Examples: Boolean
      | instruction     |
      | bool_and        |
      | bool_define     |
      | bool_depth      |
      | bool_duplicate  |
      | bool_equal_q    |
      | bool_flush      |
      | bool_from_float |
      | bool_from_int   |
      | bool_not        |
      | bool_or         |
      | bool_pop        |
      | bool_random     |
      | bool_rotate     |
      | bool_shove      |
      | bool_swap       |
      | bool_xor        |
      | bool_yank       |
      | bool_yankdup    |
    
    
    Examples: Code
      | instruction            |
      | code_atom_q            |
      | code_backbone_points   |
      | code_car               |
      | code_cdr               |
      | code_concatenate       |
      | code_cons              |
      | code_container         |
      | code_contains_q        |
      | code_define            |
      | code_depth             |
      | code_discrepancy       |
      | code_do_count          |
      | code_do_range          |
      | code_do_times          |
      | code_duplicate         |
      | code_equal_q           |
      | code_execute           |
      | code_execute_then_pop  |
      | code_flush             |
      | code_from_bool         |
      | code_from_float        |
      | code_from_int          |
      | code_from_name         |
      | code_gsub              |
      | code_if                |
      | code_instructions      |
      | code_list              |
      | code_member_q          |
      | code_name_lookup       |
      | code_noop              |
      | code_nth_cdr           |
      | code_nth               |
      | code_nth_point         |
      | code_null_q            |
      | code_parses_q          |
      | code_points            |
      | code_pop               |
      | code_position          |
      | code_quote             |
      | code.random            |
      | code_replace_nth_point |
      | code_rotate            |
      | code_shove             |
      | code_swap              |
      | code_yank              |
      | code_yankdup           |
      
    Examples: Exec
      | instruction    |
      | exec_define    |
      | exec_depth     |
      | exec_do_count  |
      | exec_do_range  |
      | exec_do_times  |
      | exec_duplicate |
      | exec_equal_q   |
      | exec_flush     |
      | exec_if        |
      | exec_k         |
      | exec_pop       |
      | exec_rotate    |
      | exec_s         |
      | exec_shove     |
      | exec_swap      |
      | exec_y         |
      | exec_yank      |
      | exec_yankdup   |
      
    Examples: Float
      | instruction          |
      | float_abs            |
      | float_add            |
      | float_cosine         |
      | float_define         |
      | float_depth          |
      | float_divide         |
      | float_duplicate      |
      | float_equal_q        |
      | float_flush          |
      | float_from_bool      |
      | float_from_int       |
      | float_greater_than_q |
      | float_if             |
      | float_less_than_q    |
      | float_max            |
      | float_min            |
      | float_modulo         |
      | float_multiply       |
      | float_negative       |
      | float_pop            |
      | float_power          |
      | float_random         |
      | float_rotate         |
      | float_shove          |
      | float_sine           |
      | float_sqrt           |
      | float_subtract       |
      | float_swap           |
      | float_tangent        |
      | float_yank           |
      | float_yankdup        |
      
    Examples: Int
      | instruction        |
      | int_abs            |
      | int_add            |
      | int_define         |
      | int_depth          |
      | int_divide         |
      | int_duplicate      |
      | int_equal_q        |
      | int_flush          |
      | int_from_bool      |
      | int_from_float     |
      | int_greater_than_q |
      | int_if             |
      | int_less_than_q    |
      | int_max            |
      | int_min            |
      | int_modulo         |
      | int_multiply       |
      | int_negative       |
      | int_pop            |
      | int_power          |
      | int_random         |
      | int_rotate         |
      | int_shove          |
      | int_subtract       |
      | int_swap           |
      | int_yank           |
      | int_yankdup        |
      
    Examples: Name
      | instruction         |
      | name_depth          |
      | name_disable_lookup |
      | name_duplicate      |
      | name_equal_q        |
      | name_flush          |
      | name_next           |
      | name_pop            |
      | name_random_bound   |
      | name_rotate         |
      | name_shove          |
      | name_swap           |
      | name_unbind         |
      | name_yank           |
      | name_yankdup        |
