require '../lib/nudge'
include Nudge


runner = Interpreter.new(
  program:"",
  instructions:Instruction.all_instructions,
  step_limit: 10000
  )

puts "pts, length, steps, init_time, run_time, stacks, stack_items, error_items"

safe_instructions = (Instruction.all_instructions-[ExecYInstruction]).collect {|i| i.to_nudgecode}

1000.times do
  t1 = Time.now
  pts = rand(300)+10
  dude = CodeType.any_value(target_size_in_points:pts, type_names:["int", "float", "bool"], instruction_names:safe_instructions)
  runner.reset(dude)
  t2 = Time.now
  runner.run
  t3 = Time.now
  stacks = runner.stacks.length
  stacked = runner.stacks.inject(0) {|sum,(k,v)| sum + v.depth}
  er = runner.stacks[:error].depth
  puts "#{pts}, #{NudgeProgram.new(dude).listing.count("\n")}, #{runner.steps}, #{t2-t1}, #{t3-t2}, #{stacks}, #{stacked}, #{er}"
  
  # if runner.steps == 10000
  #   
  #   puts "#{NudgeProgram.new(dude).listing}"
  #   break
  # end
end