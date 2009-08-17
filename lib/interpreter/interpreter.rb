require File.join(File.dirname(__FILE__), "/../nudge")

module Nudge
  class Interpreter
    include Instructions
    
    attr_accessor :variables, :names, :stacks, :step_limit, :code_limit, :steps, :NOOPs, :instructions
    
    def initialize(vars={})
      @variables = vars
      @names = {}
      @stacks = {:exec => Stack.new(:exec), :name => Stack.new(:name)}
      @step_limit = 3000
      @code_limit = 1000
      @steps = 0
      @NOOPs = 0
      @instructions = {}
    end
    
    def update_variable(var_name, var_value)
      @variables[var_name] = var_value
      extend_stacks
    end
    
    def update_name(name, value)
      @names[name] = value
    end
    
    def extend_stacks
      needed = all_requirements
      needed.each {|type| stacks[type] = stacks[type] || Stack.new(type)}
    end
    
    def load(item)
      @stacks[:exec].push item
    end
    
    def depth
      return @stacks[:exec].entries.length
    end
    
    def done?
      return @steps > @step_limit || depth==0
    end
    
    def step
      if done?
        return
      else
        item = @stacks[:exec].pop
        @steps += 1
      
        case
        when item.kind_of?(Code)
          pieces = item.split
          @stacks[:exec].entries += pieces
        when item.kind_of?(Channel)
          process_channel(item)
        when item.kind_of?(Erc)
          where = item.stackname
          @stacks[where].push item.to_literal
        when item.kind_of?(Literal)
          where = item.stackname
          @stacks[where].push item
        else
          raise RuntimeError, ":exec stack contains an unknown class"
        end
        
      end  
    end
    
    
    def process_channel(channel)
      key = channel.name
      lookup = @variables[key] || @names[key]
      if !lookup then
        @stacks[:name].push channel
      else
        @stacks[:exec].push lookup
      end
    end
    
    
    def add_instruction(name, reqs, effects)
      @instructions[name] = RegistryEntry.new(name, reqs, effects)
      extend_stacks
    end
    
    
    def all_requirements
      inst = instructions.values.collect {|v| v.stacknames}
      vars = variables.values.collect {|v| v.stackname}
      all = inst + vars
      return all.flatten.uniq
    end
  end
  
  
  class RegistryEntry
    attr_accessor :requirements, :effects
    
    def initialize(name, reqs, effs)
      @name = name
      @requirements = reqs
      @effects = effs
    end
    
    def stacknames
      return (@requirements.keys + @effects.keys).uniq
    end
  end
  
end