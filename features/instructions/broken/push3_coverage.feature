Feature: Push3 coverage
  In order to reproduce existing standard implementations of Push
  As a genetic programmer
  I want all the instructions from Push3 in Nudge

  Scenario Outline: they're all acceptably re-implemented
    When I execute the Nudge instruction "<instruction>"
    Then the :error stack should not include "UnknownInstruction"
    
    
    Examples: Boolean
      | instruction     | PUSH3               |
      | bool_and        | BOOLEAN.AND         |
      | bool_define     | BOOLEAN.DEFINE      |
      | bool_depth      | BOOLEAN.STACKDEPTH  |
      | bool_duplicate  | BOOLEAN.DUP         |
      | bool_equal?     | BOOLEAN.=           |
      | bool_flush      | BOOLEAN.FLUSH       |
      | float_positive? | BOOLEAN.FROMFLOAT   |
      | int_positive?   | BOOLEAN.FROMINTEGER |
      | bool_not        | BOOLEAN.NOT         |
      | bool_or         | BOOLEAN.OR          |
      | bool_pop        | BOOLEAN.POP         |
      | bool_random     | BOOLEAN.RAND        |
      | bool_rotate     | BOOLEAN.ROT         |
      | bool_shove      | BOOLEAN.SHOVE       |
      | bool_swap       | BOOLEAN.SWAP        |
      | bool_yank       | BOOLEAN.YANK        |
      | bool_yankdup    | BOOLEAN.YANKDUP     |

    Examples: Code
        | instruction             | PUSH3             |
        | code_atom?              | CODE.ATOM         |
        | code_backbone_points    | CODE.LENGTH       |
        | code_car                | CODE.CAR          |
        | code_cdr                | CODE.CDR          |
        | code_concatenate        | CODE.APPEND       |
        | code_cons               | CODE.CONS         |
        | code_container          | CODE.CONTAINER    |
        | code_contains?          | CODE.CONTAINS     |
        | code_define             | CODE.DEFINE       |
        | code_depth              | CODE.STACKDEPTH   |
        | code_discrepancy        | CODE.DISCREPANCY  |
        | code_do_count           | CODE.DO*COUNT     |
        | code_do_range           | CODE.DO*RANGE     |
        | code_do_times           | CODE.DO*TIMES     |
        | code_duplicate          | CODE.DUP          |
        | code_equal?             | CODE.=            |
        | code_execute            | CODE.DO*          |
        | code_execute_then_pop   | CODE.DO           |
        | code_flush              | CODE.FLUSH        |
        | code_from_bool          | CODE.FROMBOOLEAN  |
        | code_from_float         | CODE.FROMFLOAT    |
        | code_from_int           | CODE.FROMINTEGER  |
        | code_from_name          | CODE.FROMNAME     |
        | code_gsub               | CODE.SUBST        |
        | code_if                 | CODE.IF           |
      # | code_instructions       | CODE.INSTRUCTIONS |
        | code_list               | CODE.LIST         |
        | code_in_backbone?       | CODE.MEMBER       |
        | code_name_lookup        | CODE.DEFINITION   |
        | code_noop               | CODE.NOOP         |
        | code_nth_cdr            | CODE.NTHCDR       |
        | code_nth_backbone_point | CODE.NTH          |
        | code_nth_point          | CODE.EXTRACT      |
      # | code_null?              | CODE.NULL         |
        | code_points             | CODE.SIZE         |
        | code_pop                | CODE.POP          |
        | code_position           | CODE.POSITION     |
        | code_quote              | CODE.QUOTE        |
      # | code.random             | CODE.RAND         |
        | code_replace_nth_point  | CODE.INSERT       |
        | code_rotate             | CODE.ROT          |
        | code_shove              | CODE.SHOVE        |
        | code_swap               | CODE.SWAP         |
        | code_yank               | CODE.YANK         |
        | code_yankdup            | CODE.YANKDUP      |
      
    Examples: Exec
      | instruction    | PUSH3           |
      | exec_define    | EXEC.DEFINE     |
      | exec_depth     | EXEC.STACKDEPTH |
      | exec_do_count  | EXEC.DO*COUNT   |
      | exec_do_range  | EXEC.DO*RANGE   |
      | exec_do_times  | EXEC.DO*TIMES   |
      | exec_duplicate | EXEC.DUP        |
      | exec_equal?    | EXEC.=          |
      | exec_flush     | EXEC.FLUSH      |
      | exec_if        | EXEC.IF         |
      | exec_k         | EXEC.K          |
      | exec_pop       | EXEC.POP        |
      | exec_rotate    | EXEC.ROT        |
      | exec_s         | EXEC.S          |
      | exec_shove     | EXEC.SHOVE      |
      | exec_swap      | EXEC.SWAP       |
      | exec_y         | EXEC.Y          |
      | exec_yank      | EXEC.YANK       |
      | exec_yankdup   | EXEC.YANKDUP    |
      
    Examples: Float
      | instruction         | PUSH3             |
      | float_add           | FLOAT.+           |
      | float_cosine        | FLOAT.COS         |
      | float_define        | FLOAT.DEFINE      |
      | float_depth         | FLOAT.STACKDEPTH  |
      | float_divide        | FLOAT./           |
      | float_duplicate     | FLOAT.DUP         |
      | float_equal?        | FLOAT.=           |
      | float_flush         | FLOAT.FLUSH       |
      | float_from_bool     | FLOAT.FROMBOOLEAN |
      | float_from_int      | FLOAT.FROMINTEGER |
      | float_greater_than? | FLOAT.>           |
      | float_less_than?    | FLOAT.<           |
      | float_max           | FLOAT.MAX         |
      | float_min           | FLOAT.MIN         |
      | float_modulo        | FLOAT.%           |
      | float_multiply      | FLOAT.*           |
      | float_pop           | FLOAT.POP         |
      | float_random        | FLOAT.RAND        |
      | float_rotate        | FLOAT.ROT         |
      | float_shove         | FLOAT.SHOVE       |
      | float_sine          | FLOAT.SIN         |
      | float_subtract      | FLOAT.-           |
      | float_swap          | FLOAT.SWAP        |
      | float_tangent       | FLOAT.TAN         |
      | float_yank          | FLOAT.YANK        |
      | float_yankdup       | FLOAT.YANKDUP     |

    Examples: Int
      | instruction       | PUSH3               |
      | int_add           | INTEGER.+           |
      | int_define        | INTEGER.DEFINE      |
      | int_depth         | INTEGER.STACKDEPTH  |
      | int_divide        | INTEGER./           |
      | int_duplicate     | INTEGER.DUP         |
      | int_equal?        | INTEGER.=           |
      | int_flush         | INTEGER.FLUSH       |
      | int_from_bool     | INTEGER.FROMBOOLEAN |
      | int_from_float    | INTEGER.FROMFLOAT   |
      | int_greater_than? | INTEGER.>           |
      | int_less_than?    | INTEGER.<           |
      | int_max           | INTEGER.MAX         |
      | int_min           | INTEGER.MIN         |
      | int_modulo        | INTEGER.%           |
      | int_multiply      | INTEGER.*           |
      | int_pop           | INTEGER.POP         |
      | int_random        | INTEGER.RAND        |
      | int_rotate        | INTEGER.ROT         |
      | int_shove         | INTEGER.SHOVE       |
      | int_subtract      | INTEGER.-           |
      | int_swap          | INTEGER.SWAP        |
      | int_yank          | INTEGER.YANK        |
      | int_yankdup       | INTEGER.YANKDUP     |
      
    Examples: Name
      | instruction         | PUSH3              |
      | name_depth          | NAME.STACKDEPTH    |
      | name_disable_lookup | NAME.QUOTE         |
      | name_duplicate      | NAME.DUP           |
      | name_equal?         | NAME.=             |
      | name_flush          | NAME.FLUSH         |
      | name_new            | NAME.RAND          |
      | name_pop            | NAME.POP           |
      | name_random_bound   | NAME.RANDBOUNDNAME |
      | name_rotate         | NAME.ROT           |
      | name_shove          | NAME.SHOVE         |
      | name_swap           | NAME.SWAP          |
      | name_yank           | NAME.YANK          |
      | name_yankdup        | NAME.YANKDUP       |
