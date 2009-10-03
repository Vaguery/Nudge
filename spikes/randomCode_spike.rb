require '../lib/nudge'
require 'pp'
include Nudge

def randomIndentCode(points, blocks, dice=2)
  
  leaves = ["\nsample int","\nref x", "\nref x", "\ndo int_add", "\ndo int_multiply","\ndo int_divide","\ndo int_subtract","\ndo int_max","\ndo int_modulo", "\ndo int_min", "\ndo int_abs", "\ndo int_neg"]
  
  newCode = ["*"] * points
  
  blocks.times do
    length = 0
    dice.times {length += rand(6)}
    blockStart = rand(points)
    blockFinish = [blockStart+length,points-1].min
    
    until (newCode[blockStart].include? "*")
      blockStart = rand(points)
      blockFinish = [blockStart+length, points-1].min
    end
  
    newCode[blockStart] = newCode[blockStart].sub(/\*/,"\nblock {")
    newCode[blockFinish] += '}'
  end
  
  points.times do |i| 
    if newCode[i].include? "*"
      which = rand(leaves.length)
      leaf = leaves[which]
      if leaf == "\nsample int"
        leaf += ", "+IntType.any_value.to_s
      end
      newCode[i] = newCode[i].sub(/\*/,leaf)
    end
  end
  
  program = ""
  newCode.each { |i| program += i}
  
  return "block {" + program + "}"
end

@lowest = 100000000
2000.times do |step|
  parser = NudgeLanguageParser.new
  Channel.variables
  ptlength = rand(40)+10
  myCode = randomIndentCode(ptlength,ptlength/10)
  myProgram = parser.parse(myCode).to_points
  # puts myProgram.tidy

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
  print "#{step}\t"
  print "#{summedSquaredError}\t\t"
  print "#{myProgram.points}\t"
  print Stack.stacks[:int].depth.to_s + "\n"
  if summedSquaredError < @lowest
    @lowest = summedSquaredError
    puts myProgram.tidy + "\n\n"
  end
end