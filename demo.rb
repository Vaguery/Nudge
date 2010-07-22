require './nudge'

puts "points,points_evaluated,execution_time,top_int,errors,ints,bools,codes,floats,proportions"

10000.times do
  script = NudgeWriter.new.random
  exe = Executable.new(script)
  exe.bind(:x1 => Value.new(:int, 100), :x2 => Value.new(:int, 200))
  outcome = exe.run
  puts "#{NudgePoint.from(script).points},#{outcome.points_evaluated},#{outcome.execution_time},#{outcome.stacks[:int][-1]}, #{outcome.stacks[:error].length},#{outcome.stacks[:int].length},#{outcome.stacks[:bool].length},#{outcome.stacks[:code].length},#{outcome.stacks[:float].length},#{outcome.stacks[:proportion].length}"
end