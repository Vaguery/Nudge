module Nudge
  class ProgramPoint
  end
  
  class CodeBlock < ProgramPoint
    attr_accessor :listing, :contents
    
    def initialize(rawCode=nil)
      @listing = rawCode || "block {}"
    end
    
    def points
      return @listing.split(/\n/).length
    end
    
    # def go
    #   @contents.reverse.each {|item| Nudge::Stack.push!(:exec,item)} 
    # end
  end
  
  
  class Literal < ProgramPoint
    attr_accessor :type, :value
    def initialize(type,value)
      @type = type.to_sym
      @value = value
    end
    def go
      Nudge::Stack.push!(self.type,self)
    end
  end
  
  
  class Erc < ProgramPoint
    attr_accessor :type, :value
    
    def initialize(type, value=nil)
      @type = type.to_sym
      @value = value
    end
    
    def to_literal()
      Literal.new(@type,@value)
    end
    
    def go
      self.to_literal.go
    end  
  end
  
  class Channel < ProgramPoint
    attr_accessor :name
    def initialize(name)
      @name = name
    end
    # def go
    #   lookedUp = Channel.lookup(name) # returns literal
    #   lookedUp.go
    # end
  end
  
  
  
  class Instruction < ProgramPoint
    attr_accessor :name, :requirements, :effects
    def initialize(name, req={}, eff={})
      @name = name
      @requirements = req
      @effects = eff
    end
    # def go
    #   create the className 
    #   determine if it exists or not
    #   if it does, DO THAT
    #   otherwise raise an exception of some sort
    # end
    
  end
  
  
  
end