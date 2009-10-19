module Nudge
  class Location
    require 'set'
    
    def self.locations
      @locations ||= Hash.new
    end
    
    def self.cleanup
      @locations = Hash.new
    end
    
    
    attr_reader :name
    attr_accessor :downstream, :population, :capacity, :cull_rule
    
    def initialize(name, capacity = 100)
      if !Location.locations.include? name
        @name = name
        Location.locations[name] = self
        @downstream = Set.new
      else
        raise ArgumentError, "Location names must be unique"
      end
      @capacity = capacity
      @population = []
      @cull_rule = Proc.new {@population.length > @capacity}
    end
    
    def flows_into(otherPlace)
      @downstream.add(otherPlace.name)
    end
    
    def breeding_pool
      result = []
      result += @population
      @downstream.each do |place|
        result += Location.locations[place].population
      end
      return result
    end
    
    def cull?
      return cull_rule.call
    end
    
    def cull_these
      result = []
      
    end
  end
  
end