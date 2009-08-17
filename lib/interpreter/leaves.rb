module Nudge
  
  class Leaf
    attr_accessor :value, :stackname
    
    def initialize(stackname, value)
      raise TypeError, 'stackname must be a Symbol' if not stackname.kind_of? Symbol
      @stackname = stackname
      @value = value
    end
  end
  
  
  class Erc < Leaf
    attr_accessor :stackname, :value
    
    def initialize(stackname, value)
      super
      @randomizer = lambda {value}
    end
    
    def randomizer
      return @randomizer
    end
    
    def randomizer=(new_proc)
      if new_proc.kind_of? Proc
        @randomizer = new_proc
      else
        raise TypeError, "A randomizer must be a lambda or Proc object"
      end
    end
    
    def randomize(&block)
      fxn = block_given? ? block : @randomizer
      @value = self.instance_eval( &fxn )
    end
    
    def to_literal
      return Nudge::Literal.new(@stackname, @value)
    end
    
    def inspect
      return "ERC(#{@stackname.inspect},#{@value.inspect})"
    end
  end
  
  
  class Literal < Leaf
    attr_reader :stackname, :value
    
    def initialize(stackname, value)
      super
    end
    
    def to_erc
      return Nudge::Erc.new(@stackname, @value)
    end
    
    def inspect
      return @value.to_s
    end
  end
  
  
  class OpCode < Leaf
    attr_accessor :name, :requirements, :effects
    
    def initialize(name, req={}, eff={})
      @name = name
      @requirements = req
      @effects = eff
    end
  end
  
  
  
end