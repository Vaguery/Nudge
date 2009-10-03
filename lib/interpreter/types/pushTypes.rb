class NudgeType
  require 'singleton'
  include Singleton
  
  @@all_types = []
  @@active_types = []
  
  def self.inherited(subclass)
    @@all_types << subclass
    @@active_types << subclass
    super
  end
  
  def self.all_types
    @@all_types
  end
  
  def self.active_types
    @@active_types
  end
  
  def self.active?
    @@active_types.include? self
  end
  
  def self.deactivate
    @@active_types.delete self
  end
  
  def self.activate
    @@active_types << self unless @@active_types.include? self
  end
  
  def self.to_nudgecode
    self.to_s.slice(0..-5).downcase
  end
  
  def self.from_s
    raise "Your subclass of NudgeType should provide a method for parsing string values in code"
  end
end




class IntType < NudgeType
  @defaultLowest = -1000
  @defaultHighest = 1000
  
  def self.random_value(bottom = @defaultLowest, top = @defaultHighest)
    lowest, highest = [bottom,top].min, [bottom,top].max
    rand(highest-lowest).to_i + lowest
  end
  
  def self.from_s(string_value)
    return string_value.to_i
  end
  
  def self.any_value
    self.random_value
  end
end




class BoolType < NudgeType  
  def self.random_value(p = 0.5)
    rand() < p ? true : false
  end
  
  def self.from_s(string_value)
    return string_value.downcase == "true"
  end
  
  def self.any_value
    self.random_value
  end
end




class FloatType < NudgeType
  @defaultLowest = -1000.0
  @defaultHighest = 1000.0
  
  def self.random_value(bottom = @defaultLowest, top = @defaultHighest)
    bottom, top = [bottom,top].min, [bottom,top].max
    range = top - bottom
    (rand*range) + bottom
  end
  
  def self.from_s(string_value)
    return string_value.to_f
  end
  
  def self.any_value
    self.random_value
  end
end




class CodeType < NudgeType
  @@defaultPoints = 20
  
  def self.random_skeleton(points=@@defaultPoints, blocks=points/10)
    blocks = [0,[points,blocks].min].max
    if points > 1
      skel = ["block {"]
      (points-2).times {skel << " *"}
      skel << " *}"
      front = 0
      (blocks-1).times do
        until skel[front].include?("*") do
          a,b = rand(points), rand(points)
          front,back = [a,b].min, [a,b].max
        end
        skel[front] = skel[front].sub(/\*/,"block {")
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
    skel
  end
  
  def self.random_value(params={})
    points = params[:points] || @@defaultPoints
    blocks = params[:blocks] || points/10
    skeleton = params[:skeleton] || self.random_skeleton(points, blocks)
    instructions = params[:instructions] || Instruction.active_instructions
    references = params[:references] || (Channel.variables.keys + Channel.names.keys)
    types = params[:types] || NudgeType.active_types
    
    choiceCount = instructions.length + references.length + types.length # will only return samples
    
    while skeleton.include?("*") do
      which = rand(choiceCount)
      case
      when which < instructions.length
        newPoint = "do " + instructions[which].to_nudgecode
      when which < (instructions.length + references.length)
        newPoint = "ref " + references[which-instructions.length]
      else
        theType = types[which - instructions.length - references.length]
        newPoint = "sample " + theType.to_nudgecode + ", " + theType.any_value.to_s
      end
      skeleton = skeleton.sub(/\*/, newPoint)
    end
    skeleton
  end
  
  def self.from_s(string_value)
    string_value
  end
  
  def self.any_value
    self.random_value
  end
end