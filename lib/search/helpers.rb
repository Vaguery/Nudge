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
    def self.stored_state
      @stored_state
    end
    
    def self.setup(&block)
      @stored_state = block
    end
  end
end