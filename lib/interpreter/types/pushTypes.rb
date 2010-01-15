# coding: utf-8

module NudgeType
  
  def self.all_types
    @all_types ||= []
  end
  
  def self.push_types
    [IntType, BoolType, FloatType]
  end
  
  module TypeBehaviors
    def self.extended(subclass)
      NudgeType.all_types << subclass
    end
    
    def to_nudgecode
      self.to_s.demodulize.slice(0..-5).downcase.intern
    end

    def from_s(some_string)
      raise "This class must implement #{self.inspect}.from_s"
    end

    def any_value
      raise "This class must implement #{self.inspect}.any_value"
    end

    def random_value(params)
      raise "This class must implement #{self.inspect}.random_value"
    end
  end
  
  class BasicType
    def self.inherited(subclass)
      subclass.extend TypeBehaviors
    end
  end
  
  class IntType < Fixnum
    extend TypeBehaviors
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




  class BoolType
    extend TypeBehaviors

    def self.random_value(params = {})
      p = params[:randomBooleanTruthProb] || 0.5
      rand() < p
    end

    def self.from_s(string_value)
      string_value.downcase == "true" ? true : false
    end

    def self.any_value
      self.random_value
    end
  end




  class FloatType < Float
    extend TypeBehaviors

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
end
