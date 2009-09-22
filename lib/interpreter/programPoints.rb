module Nudge
  class ProgramPoint
  end
  
  
  class CodeBlock < ProgramPoint
    attr_accessor :listing, :contents
    
    def initialize(rawCode=nil)
      @listing = rawCode || "block {}"
    end
    
    def points
      @listing.split(/\n/).length
    end
    
    def go
      @contents.reverse.each {|item| Nudge::Stack.push!(:exec,item)} 
    end
    
    def tidy(level=1)
      tt = "block {"
      indent = level*2
      @contents.each {|item| tt += ("\n" + (" "*indent) + item.tidy(level+1))}
      tt += "}"
      return tt
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
    def tidy(level=1)
      "literal " + @type.to_s + ", " + @value.to_s
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
    
    def tidy(level=1)
      "erc " + @type.to_s + ", " + @value.to_s
    end
  end
  
  
  class Channel < ProgramPoint
    def self.variables
      @variables ||= {}
    end
    
    def self.bind_variable(name,value)
      if value.kind_of?(Literal)
        @variables[name] = value
      else
        raise ArgumentError
      end
    end
    
    def self.names
      @names ||= {}
    end
    
    def self.reset_variables
      @variables = {}
    end
    
    def self.reset_names
      @names = {}
    end
    
    def self.bind_name(name,value)
      if value.kind_of?(Literal)
        @names[name] = value
      else
        raise ArgumentError
      end
    end
    
    def self.lookup(var_name)
      if @variables.include?(var_name)
        @variables[var_name]
      elsif @names.include?(var_name)
        @names[var_name]
      end
    end
    
    attr_accessor :name
    
    def initialize(var_name)
      @name = var_name
    end
    
    def go
      lookedUp = Channel.lookup(@name) # returns literal
      if lookedUp
        Stack.push!(:exec, lookedUp)
      else
        Stack.push!(:name,self)
      end
    end
    
    def tidy(level=1)
      "channel " + @name
    end
  end
  
  
  class InstructionPoint < ProgramPoint
    attr_accessor :name, :requirements, :effects
    def initialize(name, req={}, eff={})
      @name = name
      @requirements = req
      @effects = eff
    end
    
    def tidy(level=1)
      "instr " + @name
    end
    
    # def go
    #   create the className 
    #   determine if it exists or not
    #   if it does, DO THAT
    #     check for preconditions (stacks have stuff)
    #   if the params exist, pop them
    #   calculate the result as a Literal
    #   push! it
    #   otherwise raise an exception of some sort
    # end
    
  end
  
  
  
end