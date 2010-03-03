#encoding: utf-8
module Nudge
  include Enumerable
  
  class ProgramPoint
    def points
      1
    end
    
    def each
      yield self
    end
  end
  
  
  class CodeblockPoint < ProgramPoint
    attr_accessor :contents
    
    def initialize(contents = [])
      raise(ArgumentError,"CodeblockPoint must be passed an Array") unless contents.kind_of?(Array)
      @contents = contents
    end
    
    def points
      @contents.inject(1) {|count, daughter| count + daughter.points}
    end
    
    def go(context)
      @contents.reverse.each {|item| context.stacks[:exec].push(item)} 
    end
    
    def tidy(level=1)
      tt = "block {"
      indent = level*2
      @contents.each {|item| tt += ("\n" + (" "*indent) + item.tidy(level+1))}
      tt += "}"
      return tt
    end
    
    def listing_parts
      fn = self.contents.inject("\n") do |fn_accumulator, branch|
        rhs = branch.listing_parts[1].empty? ? "" :  "\n#{branch.listing_parts[1]}"
        fn_accumulator + rhs
      end
      return [self.tidy, fn.strip]
    end
    
    def each
      yield self
      @contents.each do |child|
        child.each {|c| yield c}
      end
    end
  end
  
  
  class ValuePoint < ProgramPoint
    attr_accessor :type, :raw
    attr_reader :value
    
    def initialize(type,representation=nil)
      raise(ArgumentError, "Type must be a symbol or string") unless [Symbol,String].include?(type.class)
      @type = type.to_sym
      if representation != nil
        representation = representation.to_s
      end     
      @raw = representation
    end
    
    def go(context)
      context.stacks[self.type].push(self)
    end
    
    def points
      1
    end
    
    def nudgetype(typename=@type)
      "#{typename.to_s.camelize}Type"
    end
    
    def nudgetype_defined?(typename=@type)
      Nudge.const_defined?(nudgetype(typename).to_sym)
    end
    
    def value
      if @raw && nudgetype_defined?
        @value ||= nudgetype.constantize.from_s(@raw)
      else
        nil
      end
    end
    
    def tidy(level=1)
      "value «" + @type.to_s + "»"
    end
    
    def randomize(context)
      newType = context.types.sample
      @type = newType.to_nudgecode
      @raw = newType.any_value
    end
    
    def self.any(context)
      tmp = ValuePoint.new("foo", nil)
      tmp.randomize(context)
      return tmp
    end
    
    def listing_parts
      fn = @raw ? "«#{self.type}» #{self.raw}" : ""
      return [self.tidy, fn]
    end
  end
  
  
  class ReferencePoint < ProgramPoint
    def self.any(context)
      tmp = ReferencePoint.new("e")
      tmp.randomize(context)
      return tmp
    end
    
    attr_accessor :name
    alias value name
    
    def initialize(var_name)
      @name = var_name
    end
    
    def go(context)
      lookedUp = context.lookup(@name) if context.evaluate_channels
      if lookedUp
        context.stacks[:exec].push(lookedUp)
      else
        context.stacks[:name].push(self)
        context.evaluate_channels = true
      end
    end
    
    def points
      1
    end
    
    def tidy(level=1)
      "ref " + @name
    end
    
    def randomize(context)
      which = context.references.sample
      @name = which
    end
    
    def listing_parts
      [self.tidy,""]
    end
  end
  
  
  class InstructionPoint < ProgramPoint
    attr_accessor :name, :requirements, :effects
    def initialize(name)
      @name = name
    end
    
    def className
      "#{@name.camelize}Instruction"
    end
    
    def classLookup
      self.className.constantize
    rescue NameError
      raise InstructionNotFoundError, "#{self.className} not found"
    end
    
    def tidy(level=1)
      "do " + @name
    end
    
    def points
      1
    end
    
    class InstructionNotFoundError < NameError
    end
    
    def go(context)
      className = self.classLookup
      context.instructions_library[className].go
    rescue InstructionNotFoundError
      return
    end
    
    def randomize(context)
      instructionName = context.instructions.sample.to_s
      @name = instructionName.slice(0..-12).underscore
    end
    
    def self.any(context)
      tmp = InstructionPoint.new("int_add")
      tmp.randomize(context)
      return tmp
    end
    
    def listing_parts
      [self.tidy,""]
    end
  end
  
end