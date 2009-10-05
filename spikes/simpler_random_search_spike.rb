require '../lib/nudge'
include Nudge

maker = RandomGuess.new
runner = Interpreter.new

300.times do |i|
  params = {:points => rand(20)+10,
            :types => [IntType],
            :instructions => [IntAddInstruction, IntMultiplyInstruction, IntDivideInstruction, IntSubtractInstruction],
            :references => ["x1", "x2", "x3", "x4", "x5"]}
  dude = maker.generate(params)
  
  totalError = 0
  30.times do |sample|
    runner.reset(dude.genome)
    goal = 0
    ["x1", "x2", "x3", "x4", "x5"].each do |x|
      thisX = IntType.random_value
      goal += thisX
      Channel.bind_variable(x, LiteralPoint.new("int",thisX))
    end
    runner.run
    if Stack.stacks[:int].peek
      observed = Stack.stacks[:int].peek.value
    else
      observed = 30000000
    end
    expected = goal
    totalError += (expected-observed).abs
  end
  
  puts "#{totalError}\t#{dude.program.points}\t#{Stack.stacks[:int].depth}"
  # puts "\n#{dude.program.tidy}"
end