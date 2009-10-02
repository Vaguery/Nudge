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
      @contents.reverse.each {|item| Nudge::Stack.stacks[:exec].push(item)} 
    end
    
    def tidy(level=1)
      tt = "block {"
      indent = level*2
      @contents.each {|item| tt += ("\n" + (" "*indent) + item.tidy(level+1))}
      tt += "}"
      return tt
    end
  end
  
  
  class LiteralPoint < ProgramPoint
    attr_accessor :type, :value
    
    def initialize(type,value)
      @type = type.to_sym
      @value = value
    end
    
    def go
      Nudge::Stack.stacks[self.type].push(self)
    end
    
    def tidy(level=1)
      "literal " + @type.to_s + ", " + @value.to_s
    end
    
    def randomize
      all = NudgeType.active_types
      newType = all[rand(all.length)]
      @type = newType.to_s.slice(0..-5).downcase
      @value = newType.any_value
    end
    
    def self.any
      tmp = LiteralPoint.new("int", 1)
      tmp.randomize
      return tmp
    end
  end
  
  
  class Erc < ProgramPoint
    attr_accessor :type, :value
    def initialize(type, value)
      @type = type.to_sym
      @value = value
    end
    
    def to_literal()
      LiteralPoint.new(@type,@value)
    end
    
    def go
      self.to_literal.go
    end
    
    def tidy(level=1)
      "sample " + @type.to_s + ", " + @value.to_s
    end
    
    def randomize
      all = NudgeType.active_types
      newType = all[rand(all.length)]
      @type = newType.to_s.slice(0..-5).downcase
      @value = newType.any_value
    end
    
    def self.any
      tmp = Erc.new(NudgeType.all_types[0].to_s.slice(0..-5).downcase,0)
      tmp.randomize
      return tmp
    end
  end
  
  
  class Channel < ProgramPoint
    def self.variables
      @variables ||= {}
    end
    
    def self.bind_variable(name,value)
      if value.kind_of?(LiteralPoint)
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
      if value.kind_of?(LiteralPoint)
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
    
    def self.any
      tmp = Channel.new("e")
      tmp.randomize
      return tmp
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
        Stack.stacks[:name].push(self)
      end
    end
    
    def tidy(level=1)
      "channel " + @name
    end
    
    def randomize
      all = Channel.variables.keys + Channel.names.keys
      which = all[rand(all.length)]
      @name = which
    end
  end
  
  
  class InstructionPoint < ProgramPoint
    attr_accessor :name, :requirements, :effects
    def initialize(name, req={}, eff={})
      @name = name
      @requirements = req
      @effects = eff
    end
    
    def className
      "#{@name.camelize}Instruction"
    end
    
    def classLookup
      self.className.constantize
    rescue NameError
      raise InstructionNotFoundError
    end
    
    def tidy(level=1)
      "instr " + @name
    end
    
    class InstructionNotFoundError < NameError
    end
    
    def go
      self.classLookup.instance.go
    rescue InstructionNotFoundError
      return
    end
    
    def randomize
      all = Instruction.active_instructions
      className = all[rand(all.length)].to_s
      @name = className.slice(0..-12).underscore
    end
    
    def self.any
      tmp = InstructionPoint.new("int_add")
      tmp.randomize
      return tmp
    end
  end
  
end