require '../lib/nudge'
require 'pp'
include Nudge

def randomIndentCode(points, blocks, dice=2)
  
  leaves = ["\nerc int, #{rand(20)-10}","\nerc int, #{rand(10-5)}","\nerc bool, false", "\nchannel x", "\ninstr foo_bar", "\ninstr int_multiply","\ninstr int_divide"]
  
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
      newCode[i] = newCode[i].sub(/\*/,leaf)
    end
  end
  
  program = ""
  newCode.each { |i| program += i}
  
  return "block {" + program + "}"
end


parser = NudgeLanguageParser.new
Channel.variables
myCode = randomIndentCode(600,6)
puts parser.parse(myCode).to_points.tidy

ii = Interpreter.new()

(-20..20).each do |thisX|
  ii.reset(myCode)
  Channel.bind_variable("x", LiteralPoint.new(:int, thisX))
  print "#{Channel.variables["x"].value}, "
  ii.run
  # puts "INT stack:\n=========="
  # Stack.stacks[:int].entries.each  {|i| puts i.value}
  puts Stack.stacks[:int].peek.value.to_s || "nil"
  # puts "\n\nBOOL stack depth: #{Stack.stacks[:bool].depth}"
end
