require '../lib/nudge'
require 'pp'
include Nudge


@lowest = 100000000
2000.times do |step|
  parser = NudgeLanguageParser.new
  Channel.variables
  myCode = CodeType.random_value(:points => rand(20)+rand(20),:types => [IntType,BoolType,FloatType])
  p myCode
  myProgram = parser.parse(myCode).to_points
  puts myProgram.tidy + "\n\n"

  begin
    ii = Interpreter.new()
    summedSquaredError = 0
    (-20..20).each do |thisX|
      ii.reset(myCode)
      Channel.reset_variables
      Channel.bind_variable("x", LiteralPoint.new(:int, thisX))
      # print "#{Channel.variables["x"].value}, "
      ii.run
      if Stack.stacks[:int].peek != nil
        observed = Stack.stacks[:int].peek.value
        # print observed
        error = (111*thisX*thisX / (12*thisX + 6)) - observed 
      else
        # print "nil"
        error = 100000
      end
      summedSquaredError += error**2
      # print "  |  "
      # Stack.stacks[:int].entries.each {|n| print "#{n.value},"}
      # print "\n"
    end
  rescue Instruction::NaNResultError
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