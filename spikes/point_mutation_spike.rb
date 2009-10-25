require '../lib/nudge'
include Nudge


class Array
  def isolate_point(pos)
    workingCopy = self.clone
    
    # if a block, pull in items from the right until they balance
    if workingCopy[pos].include?("block")
      leftCount = workingCopy[pos].count("{")
      rightCount = workingCopy[pos].count("}")
      while leftCount > rightCount do
        workingCopy[pos] += (workingCopy[pos+1])
        workingCopy.delete_at(pos+1)
        leftCount = workingCopy[pos].count("{")
        rightCount = workingCopy[pos].count("}")
      end
    end
    
    # finish by peeling off extra closing braces
    leftCount = workingCopy[pos].count("{")
    rightCount = workingCopy[pos].count("}")
    while leftCount < rightCount do
      workingCopy[pos] = workingCopy[pos].strip
      workingCopy = workingCopy.insert(pos+1,"}")
      workingCopy[pos] = workingCopy[pos].chomp("}")
      leftCount = workingCopy[pos].count("{")
      rightCount = workingCopy[pos].count("}")
    end
    return workingCopy
  end
end

myParser = NudgeLanguageParser.new
rs = RandomGuess.new(:points => 3, :blocks => 30)
parent = rs.generate
wt = parent[0].program.listing
puts wt

pts = wt.count("\n")+1
puts "\n#{pts} program points"

newCode = myParser.parse(CodeType.random_value(:points => 1, :blocks => 0)).to_points.tidy

(0..pts-1).each do |lineNum|
  chunks = wt.split("\n")
  puts "\n#{lineNum}:\n"
  collapsed = chunks.isolate_point(lineNum)
  puts "replacing: #{myParser.parse(collapsed[lineNum]).to_points.tidy}\n\n"
  collapsed[lineNum] = "do NOTHING"
  puts "-> #{myParser.parse(collapsed.join("\n")).to_points.tidy}"
end

