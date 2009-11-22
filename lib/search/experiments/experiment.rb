module Nudge
  
  class Experiment
    attr_reader :name
    attr_accessor :config
    attr_accessor :data_path
    attr_accessor :instructions, :types, :variable_names
    attr_accessor :station_names, :objectives
    
    def initialize(options = {})
      @name = options[:name] || 'default_experiment'
      @config = Nudge::Config.new
      @instructions = Instruction.all_instructions
      @types = [BoolType, FloatType, IntType]
      @variable_names = []
      
      # paths
      @data_path = options[:data_path] || '../data'
      
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
    
    def connect_stations(flow_from, flow_to)
      raise ArgumentError, "Unknown station: #{flow_from}" if !station_known?(flow_from)
      raise ArgumentError, "Unknown station: #{flow_from}" if !station_known?(flow_to)
      Station.stations[flow_from].flows_into Station.stations[flow_to]
    end
    
  end
end