module Nudge
  
  class Experiment
    attr_reader :name, :config_path
    
    def initialize(options = {})
      @name = options[:name] || 'default_experiment'
      @config_path = options[:config_path] || '../config'
    end
    
  end
  
end