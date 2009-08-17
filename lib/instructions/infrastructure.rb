module Instructions

  class Instruction
    attr_reader :requirements, :effects, :context
    
    def initialize(context = nil, requirements={}, effects={})
      @requirements = requirements
      @effects = effects
      @context = context
    end
    
    def ready?
      ready = true
      @requirements.each do |stack,count|
        ready &&= (@context.stacks[stack].depth >= count)
      end
      return ready
    end
    
    def run()
    end
  end

end
