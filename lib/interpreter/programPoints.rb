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
    
    def go
      @contents.reverse.each {|item| Nudge::Stack.push!(:exec,item)} 
    end
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
    def self.variables
      @variables ||= {}
    end
    
    def self.bind_variable(name,value)
      @variables[name] = value
    end
    
    def self.names
      @names ||= {}
    end
    
    def self.bind_name(name,value)
      @names[name] = value
    end
    
    def self.lookup(var_name)
      if @variables.include?(var_name)
        return @variables[var_name]
      elsif @names.include?(var_name)
        return @names[var_name]
      end
    end
    
    attr_accessor :name
    
    def initialize(var_name)
      @name = var_name
    end
    
    def go
      lookedUp = Channel.lookup(@name) # returns literal
      if lookedUp
        Stack.stacks[:exec].push(lookedUp)
      else
        Stack.push!(:name,self)
      end
    end
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