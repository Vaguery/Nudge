module Nudge
  class Location
    require 'set'
    
    
    def self.locations
      if @locations
        @locations
      else
        Hash[:DEAD,DeadLocation.new]
      end
    end
    
    
    def self.cleanup
      @locations = Hash[:DEAD,DeadLocation.new]
    end
    
    
    attr_reader :name
    attr_accessor :downstream, :population, :capacity,:cull_rule, :generate_rule, :promotion_rule
    
    
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
      @generate_rule = Proc.new { [Individual.new(CodeType.any_value)] }
      @promotion_rule = Proc.new { |indiv| false } # will need to take an Individual as a param
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
    
    
    def add_individual(newDude)
      newDude.location = @name
      @population << newDude
    end
    
    
    def transfer(popIndex, newLocationName)
      if popIndex < 0 || popIndex > @population.length
        raise ArgumentError, "self#transfer called with index #{popIndex}"
      end
      if !Location.locations.include?(newLocationName)
        raise ArgumentError, "self#transfer called with nonexistent location \"#{newLocationName}\""
      end
      
      movedDude = @population[popIndex]
      Location.locations[newLocationName].population << movedDude
      @population.delete_at(popIndex)
      movedDude.location = newLocationName
    end
    
    
    def promote?(myDude)
      return @promotion_rule.call(myDude)
    end
    
    
    def promote(popIndex, newLocationName = nil)
      if newLocationName
        if !@downstream.include?(newLocationName)
          raise ArgumentError, "\"#{@name}\" is not connected to location \"#{newLocationName}\""
        end
      else
        newLocationName = @downstream.to_a.sample || self.name
      end
      self.transfer(popIndex,newLocationName)
    end
    
    
    def cull?
      return cull_rule.call
    end
    
    
    def cull_order
      result = @population.shuffle
      return result
    end
    
    
    def cull
      lottery = self.cull_order
      while self.cull?
        where = @population.find_index(lottery[0])
        self.transfer(where, :DEAD)
        lottery.delete_at(0)
      end
    end
  end
  
  
  
  
  class DeadLocation < Location
    def initialize()
      @name = :DEAD
      @capacity = nil
      @population = []
    end
  end
end