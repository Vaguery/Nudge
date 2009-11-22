module Nudge
  
  class Experiment
    attr_reader :name
    attr_accessor :config
    attr_accessor :data_path
    attr_accessor :instructions, :types, :variable_names
    attr_accessor :stations, :objectives
    
    def initialize(options = {})
      @name = options[:name] || 'default_experiment'
      @config = Nudge::Config.new
      @instructions = Instruction.all_instructions
      @types = [BoolType, FloatType, IntType]
      @variable_names = []
      
      # paths
      @data_path = options[:data_path] || '../data'
      
      # infrastructure
      @stations = []
      @objectives = {}
      
      Nudge::Config.stored_state.call(self) unless !Config.stored_state
    end
    
    def start_search
      
    end
    
  end
  
end