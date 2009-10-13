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
  
  def evaluate(generation, runner)
    totalError = 0
    totalExceptions = 0
    sampleSize = 5*generation+10
    sampleSize.times do |sample|
      runner.reset(@genome)
      x1now = rand(1000)
      x2now = rand(1000)
      goal = x1now+x2now+6
      Channel.bind_variable("x1", LiteralPoint.new("int",x1now))
      Channel.bind_variable("x2", LiteralPoint.new("int",x2now))
      ["x3", "x4", "x5"].each do |x|
        thisX = rand(2000)-1000
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

    @scores['accuracy'] = totalError.to_f/sampleSize
    @scores['length'] = @program.points
    @scores['leftovers'] = Stack.stacks[:int].depth
    @scores['errors'] = totalExceptions
  end
end





maker = RandomGuess.new
sampler = RandomResample.new
runner = Interpreter.new
winners = NondominatedSubset.new
mater = UniformBackboneCrossover.new
params = {:points => 30,
          :types => [IntType, FloatType],
          :instructions => [IntAddInstruction, IntMultiplyInstruction, IntNegativeInstruction, IntSubtractInstruction, IntDivideInstruction, FloatAddInstruction, FloatMultiplyInstruction,FloatSubtractInstruction, FloatDivideInstruction, IntFromFloatInstruction, FloatFromIntInstruction],
          :references => ["x1", "x2", "x3", "x4", "x5"]}
popSize = 100

population = maker.generate(popSize,params)

population.each do |dude|
  dude.evaluate(0,runner)
  dude.save()
end

(1..20).each do |generation|
  population.each do |dude|
    puts "#{generation}\t#{dude.scores['accuracy']}\t#{dude.scores['length']}\t#{dude.scores['leftovers']}\t#{dude.scores['errors']}"
  end
  
  nextGen = []
  nextGen += winners.generate(population,['accuracy'])
  
  until nextGen.length >= popSize do
    tourney = sampler.generate(population,30)
    parents = winners.generate(tourney,['accuracy','leftovers'])
    newKids = mater.generate(parents,2)
    newKids.each {|dude| dude.evaluate(generation,runner)}
    keepers = winners.generate(newKids,['accuracy', 'length'])
    nextGen = nextGen + keepers
  end
  
  population = nextGen
end


