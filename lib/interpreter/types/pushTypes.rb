
class NudgeType
  require 'singleton'
  include Singleton
  
  def self.from_s
    raise "Your subclass of NudgeType should provide a method for parsing string values in code"
  end
end




class IntType < NudgeType
  @defaultLowest = -1000
  @defaultHighest = 1000
  
  def self.randomize(bottom = @defaultLowest, top = @defaultHighest)
    bottom, top = [bottom,top].min, [bottom,top].max
    rand(top-bottom) + bottom
  end
  
  def self.from_s(string_value)
    return string_value.to_i
  end
  
  def self.any_value
    self.randomize
  end
end




class BoolType < NudgeType
  def self.randomize(p = 0.5)
    rand() < p ? true : false
  end
  
  def self.from_s(string_value)
    return string_value.downcase == "true"
  end
  
  def self.any_value
    self.randomize
  end
end




class FloatType < NudgeType
  @defaultLowest = -1000.0
  @defaultHighest = 1000.0
  
  def self.randomize(bottom = @defaultLowest, top = @defaultHighest)
    bottom, top = [bottom,top].min, [bottom,top].max
    range = top - bottom
    (rand*range) + bottom
  end
  
  def self.from_s(string_value)
    return string_value.to_f
  end
  
  def self.any_value
    self.randomize
  end
end
