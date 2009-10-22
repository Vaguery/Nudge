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
  
  
  def self.any_type(types = NudgeType.active_types)
    raise(ArgumentError,"no available NudgeTypes") if types.empty?
    return types.sample
  end
  
  
  def self.any_instruction(instructions = Instruction.active_instructions)
    raise(ArgumentError,"no available Instructions") if instructions.empty?
    return instructions.sample
  end
  
  
  def self.any_reference(refs = (Channel.variables.keys + Channel.names.keys))
    raise(ArgumentError,"no available references") if refs.empty?
    return refs.sample
  end
  
  
  def self.roulette_wheel(references, instructions, types)
    basis = Hash["reference", references.length,
      "instruction", instructions.length,
      "sample", types.length]
    sum = basis.values.inject(:+)
    spin = rand(sum)
    basis.each do |result,weight|
      return result if spin <= weight && weight > 0
      spin -= weight
    end
    raise "A problem occurred when executing CodeType#roulette_wheel"
  end
  
  
  def self.random_value(params = {})
    points = params[:points] || @@defaultPoints
    blocks = params[:blocks] || points/10
    skeleton = params[:skeleton] || self.random_skeleton(points, blocks)
    instructions = params[:instructions] || Instruction.active_instructions
    references = params[:references] || (Channel.variables.keys + Channel.names.keys)
    types = params[:types] || NudgeType.active_types
    
    while skeleton.include?("*") do
      case self.roulette_wheel(references,instructions,types)
      when "instruction"
        newPoint = " do " + self.any_instruction(instructions).to_nudgecode
      when "reference"
        newPoint = " ref " + self.any_reference(references)
      when "sample"
        theType = any_type(types)
        if theType == CodeType
          if types != [CodeType]
            theType = self.any_type(types - [CodeType])
          else
            raise ArgumentError, "Random code cannot be created"
          end
        end
        newPoint = " sample " + theType.to_nudgecode + " (" + theType.any_value.to_s + ")"
      else
        raise ArgumentError, "Nothing to make random code from"
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