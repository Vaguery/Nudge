module Nudge
  class Station
    require 'set'
    
    def self.stations
      @stations ||= self.cleanup
    end
    
    def self.cleanup
      @stations = Hash[:DEAD,DeadStation.new]
    end
    
    
    attr_reader :name
    attr_accessor :downstream, :population, :capacity
    attr_accessor :settings
    attr_accessor :database
    attr_accessor :cull_check, :generate_rule, :promotion_rule, :cull_rule
    
    
    def initialize(name, params = {})
      if !Station.stations.include? name
        @name = name
      else
        raise ArgumentError, "Station names must be unique"
      end
      
      @capacity = params[:capacity] || 100
      @settings = InterpreterSettings.new(params)
      @population = []
      @downstream = Set.new
      
      @generate_rule = params[:generate_rule] || Proc.new { |crowd| RandomGuessOperator.new.generate}
      @promotion_rule = params[:promotion_rule] || Proc.new { |indiv| false }
      @cull_check = params[:cull_check] || Proc.new {@population.length > @capacity}
      
      @database = "#{params[:database]}/#{@name}" || ("http://localhost:5984/" + @name)
      
      Station.stations[@name] = self
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
      newDude.station = self
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
      movedDude.station = Station.stations[newStationName]
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
      return cull_check.call
    end
    
    
    def review_and_cull
    end
    
    
    def cull_all
      @population.length.times do
        self.transfer(0, :DEAD)
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
    
    def core_cycle
    end
  end
end