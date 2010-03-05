module Nudge
  require 'open-uri'
  
  class Factory
    attr_reader :name
    attr_accessor :config
    attr_accessor :couch_url
    attr_accessor :instructions, :types, :variable_names
    attr_accessor :station_names, :objectives
    
    def initialize(options = {})
      @name = options[:name] || 'default_factory'
      @config = Nudge::Config.new
      @instructions = Instruction.all_instructions
      @types = [BoolType, FloatType, IntType]
      @variable_names = []
      
      # paths
      @couch_url = options[:couch_url] || 'http://localhost:5984'
      
      # infrastructure
      @station_names = []
      @objectives = {}
      
      Nudge::Config.stored_state.call(self) unless !Config.stored_state
    end
    
    def build_station(name, params = {})
      new_s = Station.new(name, params)
      self.station_names << new_s.name
    end
    
    def station_known?(name)
      return @station_names.include?(name)
    end
    
    def couch_live?
      begin
        ack = (open(@couch_url) {|db| db.status[0]} == "200")
      rescue SocketError # there may be more exceptions to catch!
        ack = false
      end
      return ack
    end
    
    def connect_stations(flow_from, flow_to)
      raise ArgumentError, "Unknown station: #{flow_from}" if !station_known?(flow_from)
      raise ArgumentError, "Unknown station: #{flow_from}" if !station_known?(flow_to)
      Station.stations[flow_from].flows_into Station.stations[flow_to]
    end
    
  end
end