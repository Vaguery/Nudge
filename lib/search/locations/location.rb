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
    attr_accessor :downstream, :upstream
    
    def initialize(name)
      if !Location.locations.include? name
        @name = name
        Location.locations[name] = self
        @downstream = Set.new
      else
        raise ArgumentError, "Location names must be unique"
      end
    end
    
    def flows_into(otherPlace)
      @downstream.add(otherPlace.name)
    end
  end
  
end