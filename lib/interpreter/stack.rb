module Nudge
  class Stack
    def self.stacks
      @stacks ||= {}
    end
    
    def self.cleanup
      @stacks = nil
    end
    
    def self.push!(name,item)
      name = name.to_sym
      if self.stacks.include?(name)
        self.stacks[name].push item
      else
        self.stacks[name] = Stack.new(name)
        self.push!(name,item)
      end
    end
    
    attr_accessor :entries
    attr_reader :name
    
    def initialize(name)
      @name = name
      @entries = []
      self.class.stacks[name] = self
    end
    
    def push(item)
      @entries.push(item) unless item == nil
    end
    
    def pop
      return @entries.pop
    end
    
    def peek
      return @entries.last
    end
    
    def depth
      @entries.length
    end
    
  end
  
end