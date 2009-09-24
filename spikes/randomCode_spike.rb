require '../lib/nudge'
require 'pp'
include Nudge

def randomIndentCode(points, blocks, dice=2)
  
  leaves = ["\nerc int, -2","\nerc int, 11","\nerc bool, false", "\nchannel y", "\ninstr int_add", "\ninstr int_multiply","\ninstr int_divide"]
  
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
Channel.bind_variable("y", LiteralPoint.new(:int, 9))
myCode = randomIndentCode(20,0)
puts parser.parse(myCode).to_points.tidy

ii = Interpreter.new()
ii.reset(myCode)
puts "\n\n"
ii.run
puts "INT stack:\n=========="
Stack.stacks[:int].entries.each  {|i| puts i.value}
puts "\n\nBOOL stack depth: #{Stack.stacks[:bool].depth}"
