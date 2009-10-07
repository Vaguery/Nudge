require '../lib/nudge'
require 'couchrest'
include Nudge

class Individual
  def self.connection
    @db ||= CouchRest.database!("http://127.0.0.1:5984/nudge_spike1")
  end
  
  def save()
    response = self.class.connection.save_doc({:genome => @genome, :program => @program, :scores => @scores, :birthday => @timestamp})
    @id = response['id']
    return self
  end
end


maker = RandomGuess.new
runner = Interpreter.new


200.times do |i|
  params = {:points => rand(20)+10,
            :types => [IntType,BoolType,FloatType],
            :references => ["x1", "x2", "x3", "x4", "x5"]}
  dude = maker.generate(params)[0]
  
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
  
  dude.scores['accuracy'] = totalError
  dude.scores['length'] = dude.program.points
  dude.scores['leftovers'] = Stack.stacks[:int].depth
  puts "#{dude.scores.inspect}"
  dude.save
end