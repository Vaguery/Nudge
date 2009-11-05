module Nudge
  class Station
    require 'set'
    
    def self.stations
      if @stations
        @stations
      else
        Hash[:DEAD,DeadStation.new]
      end
    end
    
    def self.cleanup
      @stations = Hash[:DEAD,DeadStation.new]
    end
    
    
    attr_reader :name
    attr_accessor :downstream, :population, :capacity
    attr_accessor :settings
    attr_accessor :cull_trigger, :generate_rule, :promotion_rule
    
    
    def initialize(name, capacity = 100, params = {})
      if !Station.stations.include? name
        @name = name
        Station.stations[name] = self
        @downstream = Set.new
      else
        raise ArgumentError, "Station names must be unique"
      end
      @capacity = capacity
      @settings = Settings.new(params)
      @population = []
      @cull_trigger = Proc.new {@population.length > @capacity}
      @generate_rule = Proc.new { |crowd| RandomGuessOperator.new.generate}
      @promotion_rule = Proc.new { |indiv| false } # will need to take an Individual as a param
    end
    
    
    def flows_into(otherPlace)
      @downstream.add(otherPlace.name)
    end
    
    
    def breeding_pool
      result = []
      result += @population
      @downstream.each do |place|
        result += Station.stations[place].population
      end
      return result
    end
    
    
    def add_individual(newDude)
      newDude.station = @name
      @population << newDude
    end
    
    
    def transfer(popIndex, newStationName)
      if popIndex < 0 || popIndex > @population.length
        raise ArgumentError, "self#transfer called with index #{popIndex}"
      end
      if !Station.stations.include?(newStationName)
        raise ArgumentError, "self#transfer called with nonexistent station \"#{newStationName}\""
      end
      
      movedDude = @population[popIndex]
      Station.stations[newStationName].population << movedDude
      @population.delete_at(popIndex)
      movedDude.station = newStationName
    end
    
    
    def promote?(myDude)
      return @promotion_rule.call(myDude)
    end
    
    
    def promote(popIndex, newLoc = nil)
      if newLoc
        raise(ArgumentError,
          "\"#{@name}\" is not connected to \"#{newLoc}\"") if !@downstream.include?(newLoc)
      else
        newLoc = @downstream.to_a.sample || self.name
      end
      self.transfer(popIndex,newLoc)
    end
    
    
    def review_and_promote
      up_for_promotion = @population.find_all {|dude| self.promote?(dude) }
      up_for_promotion.each {|dude| self.promote(@population.find_index(dude)) }
    end
    
    
    def cull?
      return cull_trigger.call
    end
    
    
    def cull_order
      result = @population.shuffle
      return result
    end
    
    
    def review_and_cull
      lottery = self.cull_order
      while self.cull?
        where = @population.find_index(lottery[0])
        self.transfer(where, :DEAD)
        lottery.delete_at(0)
      end
    end
    
    
    def generate
      prospects = self.breeding_pool
      my_babies = self.generate_rule.call( prospects )
      @population += my_babies
    end
    
    
    def core_cycle
      self.generate
      self.review_and_promote
      self.review_and_cull
    end
  end
  
  
  
  
  class DeadStation < Station
    def initialize()
      @name = :DEAD
      @capacity = nil
      @population = []
    end
  end
end