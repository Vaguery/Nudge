module Nudge
  
  class Stack
    attr_accessor :entries
    attr_reader :name
    
    def initialize(name)
      @name = name
      @entries = []
    end
    
    def push(item)
      @entries.push(item)
    end
    
    def pop
      return @entries.pop
    end
    
    def peek
      return @entries.last
    end
    
    def depth
      return @entries.length
    end
    
  end
  
end