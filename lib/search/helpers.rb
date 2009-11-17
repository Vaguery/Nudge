module Nudge
  class Settings
    attr_accessor :instructions, :references, :types
    
    def initialize(params = {})
      @instructions = params[:instructions] || Instruction.all_instructions 
      @references = params[:references] || []
      @types = params[:types] || NudgeType.push_types
    end
  end
  
  
  class Config
    def self.block
      @block
    end
    
    def self.setup(&block)
      @block = block
    end
  end
end