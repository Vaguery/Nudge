# coding: utf-8

class CodeType < NudgeType
  @@defaultPoints = 20
  
  def self.random_skeleton(points=@@defaultPoints, blocks=points/10)
    blocks = [0,[points,blocks].min].max
    
    if points > 1
      skel = ["block {"]
      (points-2).times {skel << "*"}
      skel << "*}"
      front = 0
      (blocks-1).times do
        until skel[front].include?("*") do
          a,b = rand(points), rand(points)
          front,back = [a,b].min, [a,b].max
        end
        skel[front] = skel[front].sub(/\*/," block {")
        skel[back] = skel[back] + "}"
      end
      skel = skel.join
    else
      if blocks>0
        skel = "block {}"
      else
        skel = "*"
      end
    end
    return skel
  end
  
  def self.pick_a_type(types)
    raise ArgumentError if types.empty?
    return types.sample
  end
  
  def self.random_value(params={})
    points = params[:points] || @@defaultPoints
    blocks = params[:blocks] || points/10
    skeleton = params[:skeleton] || self.random_skeleton(points, blocks)
    instructions = params[:instructions] || Instruction.active_instructions
    references = params[:references] || (Channel.variables.keys + Channel.names.keys)
    types = params[:types] || NudgeType.active_types
    
    iCount, rCount, tCount = instructions.length, references.length, types.length
    allCount = iCount + rCount + tCount
    if allCount == 0 
      raise ArgumentError, "Nothing to make random code from"
    end
    
    while skeleton.include?("*") do
      whichPoint = rand(allCount)
      case
      when whichPoint < iCount
        newPoint = " do " + instructions[whichPoint].to_nudgecode
      when whichPoint < (iCount + rCount)
        newPoint = " ref " + references[whichPoint-iCount]
      else
        theType = types[whichPoint - iCount - rCount]
        if theType == CodeType
          if types != [CodeType]
            theType = self.pick_a_type(types - [CodeType])
          else
            raise ArgumentError, "Random code cannot be created"
          end
        end
        newPoint = " sample " + theType.to_nudgecode + " (" + theType.any_value.to_s + ")"
      end
      skeleton = skeleton.sub(/\*/, newPoint)
      skeleton = skeleton.sub(/\n/,'')
    end
    skeleton
  end
  
  
  def self.from_s(string_value)
    return string_value.sub(/\(/,"«").sub(/\)/,"»")
  end
  
  def self.any_value
    self.random_value
  end
end