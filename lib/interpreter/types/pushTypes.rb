# coding: utf-8

class NudgeType
  require 'singleton'
  include Singleton
  
  @@all_types = []
  
  def self.inherited(subclass)
    @@all_types << subclass
    super
  end
  
  def self.all_types
    @@all_types
  end
  
  def self.push_types
    [IntType, BoolType, FloatType]
  end
  
  def self.to_nudgecode
    self.to_s.slice(0..-5).downcase
  end
  
  def self.from_s
    raise "Your subclass of NudgeType should provide a method for parsing string values in code"
  end
end




class IntType < NudgeType
  @defaultLowest = -100
  @defaultHighest = 100
  
  def self.defaultLowest
    @defaultLowest
  end
  
  def self.defaultHighest
    @defaultHighest
  end
  
  def self.random_value(params={})
    bottom = params[:randomIntegerLowerBound] || @defaultLowest
    top = params[:randomIntegerUpperBound] || @defaultHighest
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
  def self.random_value(params = {})
    p = params[:randomBooleanTruthProb] || 0.5
    rand() < p
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
  
  def self.random_value(params = {})
    bottom = params[:randomFloatLowerBound] || @defaultLowest
    top = params[:randomFloatUpperBound] || @defaultHighest
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