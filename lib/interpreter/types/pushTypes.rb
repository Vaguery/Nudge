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