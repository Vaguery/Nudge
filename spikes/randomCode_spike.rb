require '../lib/nudge'
include Nudge

def randomIndentCode(points, blocks, dice=2)
  
  leaves = ["\nerc int, X", "\nchannel y", "\ninstr foo", "\ninstr bar"]
  
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
      which = rand(4)
      leaf = leaves[which]
      newCode[i] = newCode[i].sub(/\*/,leaf)
    end
  end
  
  program = ""
  newCode.each { |i| program += i}
  
  return "block {" + program + "}"
end


parser = NudgeLanguageParser.new
puts parser.parse(randomIndentCode(30,12)).to_points.tidy
