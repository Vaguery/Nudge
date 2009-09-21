module Nudge
  class CodeBlock
    attr_accessor :listing, :contents
    
    def initialize(rawCode=nil)
      @listing = rawCode || "block {}"
    end
    
    def points
      return @listing.split(/\n/).length
    end
  end
  
  
  class Literal
    attr_accessor :type, :value
    def initialize(type,value)
      @type = type
      @value = value
    end
  end
  
  
  class Erc
    attr_accessor :type, :value
    def initialize(type, value=nil)
      @type = type
      @value = value
    end
  end
  
  
  class Instruction
    attr_accessor :name, :requirements, :effects
    def initialize(name, req={}, eff={})
      @name = name
      @requirements = req
      @effects = eff
    end
  end
  
  
  class Channel
    attr_accessor :name
    def initialize(name)
      @name = name
    end
  end
  
  
end