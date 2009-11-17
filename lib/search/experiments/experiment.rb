module Nudge
  
  class Experiment
    attr_reader :name
    attr_accessor :config_path, :data_path
    attr_accessor :stations, :objectives
    
    def initialize(options = {})
      @name = options[:name] || 'default_experiment'
      
      # paths
      @config_path = options[:config_path] || '../config'
      @data_path = options[:data_path] || '../data'
      
      # infrastructure
      @stations = []
      @objectives = {}
      
      
      # Config.block.instance_eval(self)
      # vs. Config.stored.instance_eval(self)
    end
    
    def start_search
      
    end
    
  end
  
end