require 'nudge'
include Nudge

runner = Interpreter.new(
  "",
  instructions:Instruction.all_instructions,
  step_limit: 10000)
  

safe_instructions = (Instruction.all_instructions-[ExecYInstruction]).collect {|i| i.to_nudgecode}


100.times do |i|
    pts = rand(40)+10
    
    dude = CodeType.any_value(
      target_size_in_points:pts,
      type_names:["int", "float", "bool", "code"], 
      instruction_names:safe_instructions, 
      reference_names:["x1"]) 
    
    perf = ""
    (-50..50).each do |input|
      runner.reset(dude)
      runner.bind_variable("x1", ValuePoint.new("int", input))
      runner.register_sensor("y1") {|me| me.pop_value(:int)}
      runner.run
      perf << "#{runner.steps},"
    end
    puts perf
end

