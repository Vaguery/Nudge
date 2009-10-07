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
sampler = RandomResample.new
runner = Interpreter.new
winners = NondominatedSubset.new
mater = UniformBackboneCrossover.new
params = {:points => 30,
          :blocks => 5,
          :types => [IntType, FloatType],
          :instructions => [IntAddInstruction, IntMultiplyInstruction, IntNegativeInstruction, IntSubtractInstruction, IntDivideInstruction, FloatAddInstruction, FloatMultiplyInstruction,FloatSubtractInstruction, FloatDivideInstruction, IntFromFloatInstruction, FloatFromIntInstruction],
          :references => ["x1", "x2", "x3", "x4", "x5"]}
popSize = 100


population = maker.generate(params, popSize)


50.times do |generation|
  population.each do |dude|
    totalError = 0
    totalExceptions = 0
    sampleSize = 30+generation
    sampleSize.times do |sample|
      runner.reset(dude.genome)
      x1now = IntType.random_value
      x2now = IntType.random_value
      goal = x1now+x2now+6
      Channel.bind_variable("x1", LiteralPoint.new("int",x1now))
      Channel.bind_variable("x2", LiteralPoint.new("int",x2now))
      ["x3", "x4", "x5"].each do |x|
        thisX = IntType.random_value
        Channel.bind_variable(x, LiteralPoint.new("int",thisX))
      end
      begin
        runner.run
      rescue
        totalExceptions += 1
      end
      if Stack.stacks[:int].peek
        observed = Stack.stacks[:int].peek.value
      else
        observed = 30000000
      end
      expected = goal
      totalError += (expected-observed+rand()).abs 
    end
  
    dude.scores['accuracy'] = totalError.to_f/sampleSize
    dude.scores['length'] = dude.program.points
    dude.scores['leftovers'] = Stack.stacks[:int].depth
    dude.scores['errors'] = totalExceptions
    puts "#{generation}\t#{dude.scores['accuracy']}\t#{dude.scores['length']}\t#{dude.scores['leftovers']}\t#{dude.scores['errors']}"
  end
  
  parents = []
  until parents.length >= popSize do
    tourney = sampler.generate(population,10)
    parents += winners.generate(tourney,['accuracy', 'length'])
  end
  
  nextGen = winners.generate(population,['accuracy'])
  # nextGen.each {|winner| puts winner.program.tidy}
  nextGen += mater.generate(parents,popSize-nextGen.length)
  population = nextGen
end