require '../lib/nudge'
require 'pp'
include Nudge


@lowest = 100000000
parser = NudgeLanguageParser.new
2000.times do |step|
  Channel.variables
  myCode = CodeType.random_value(:points => rand(30)+rand(20),:types => [BoolType, IntType, FloatType]*10, :references => ["x"]*20)
  myProgram = parser.parse(myCode).to_points
  # puts myProgram.tidy + "\n\n"

  ii = Interpreter.new()
  summedSquaredError = 0
  50.times do 
    thisX = rand(200)-100
    ii.reset(myCode)
    Channel.reset_variables
    Channel.bind_variable("x", LiteralPoint.new(:int, thisX))
    begin
      ii.run
      if Stack.stacks[:int].peek != nil
        observed = Stack.stacks[:int].peek.value
        error = (111*thisX*thisX / (12*thisX + 6)) - observed 
      else
        error = 100000
      end
    rescue Instruction::NaNResultError
      error = 100000
    end
    summedSquaredError += error**2
  end
  print "#{step}\t"
  print "#{summedSquaredError}\t\t"
  print "#{myProgram.points}\t"
  print Stack.stacks[:int].depth.to_s + "\n"
  if summedSquaredError < @lowest
    @lowest = summedSquaredError
    puts myProgram.tidy + "\n\n"
  end
end