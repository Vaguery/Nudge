require '../lib/nudge'
include Nudge

runner = Interpreter.new(
  "",
  instructions:Instruction.all_instructions,
  step_limit: 10000)


puts "pts, length, steps, init_time, run_time, stacks, stack_items, error_items, sensors"

safe_instructions = (Instruction.all_instructions-[ExecYInstruction]).collect {|i| i.to_nudgecode}

total_instructions = 0
total_time = 0

10000.times do |i|
    t1 = Time.now
    pts = rand(40)+10
    dude = CodeType.any_value(target_size_in_points:pts, type_names:["int", "float", "bool", "code"], instruction_names:safe_instructions, reference_names:["x1", "x2"])    
    runner.reset(dude)
    
    puts "\n\n#{dude.inspect}"
    
    runner.bind_variable("x1", ValuePoint.new("int", 1900))
    runner.bind_variable("x2", ValuePoint.new("int", 2010))
    runner.register_sensor("y1") {|me| me.pop_value(:int)}
    runner.register_sensor("y2") {|me| me.pop_value(:float)}
    t2 = Time.now
    fired = runner.run
    t3 = Time.now
    stacks = runner.stacks.length
    stacked = runner.stacks.inject(0) {|sum,(k,v)| sum + v.depth}
    er = runner.stacks[:error].depth
    total_instructions += runner.steps
    total_time += (t3-t2)
  
    puts "#{i}, #{pts}, #{NudgeProgram.new(dude).blueprint.count("\n")}, #{runner.steps}, #{t2-t1}, #{t3-t2}, #{stacks}, #{stacked}, #{er}, #{i/total_time}; results: #{fired}"
  
    # if (t3-t2 > 2) || (runner.steps > 1000 && runner.steps < 9000)
    #   puts NudgeProgram.new(dude).blueprint
    # end
end

