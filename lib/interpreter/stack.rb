module Nudge
  class Stack
    def self.stacks
      @stacks ||=  Hash.new {|hash, key| hash[key] = Stack.new(key) }
    end
    
    def self.cleanup
      @stacks = Hash.new {|hash, key| hash[key] = Stack.new(key) }
    end
    
    attr_accessor :entries
    attr_reader :name
    
    def initialize(name)
      @name = name
      @entries = []
      Stack.stacks[@name] = self
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