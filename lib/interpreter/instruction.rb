module Nudge
  
  class Instruction
    
    attr_accessor :name, :requirements, :effects
    
    def initialize(name, req={}, eff={})
      @name = name
      @requirements = req
      @effects = eff
    end
  
  end
  
end