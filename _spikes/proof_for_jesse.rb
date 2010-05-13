require '../lib/nudge'
include Nudge

runner = Interpreter.new(
  "block {\n  block {\n    do code_cons\n    do name_random_bound\n    ref aaa001\n    ref aaa002\n    do name_swap\n    ref aaa003}\n  do code_nth_point\n  block {\n    ref aaa004}\n  do code_pop\n  do float_sqrt\n  value «code»\n  value «code»\n  block {\n    value «bool»\n    ref aaa005\n    value «bool»\n    do code_do_range}} \n«code» block {do bool_shove block {} }\n«code» block {value «float» value «float» do int_shove }\n«float» 951.53009657343\n«float» -956.009889769403\n«bool» true\n«bool» false",
  instructions:Instruction.all_instructions,
  step_limit: 10000)
  
runner.run

runner.stacks.each {|s| puts s.inspect}
