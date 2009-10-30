module Nudge
  
  # Nudge Stacks are Arrays with some added convenience functions.
  class Stack
    delegate :clear, :to => :entries
    
    attr_accessor :entries
    attr_reader :name
    
    # Stack name must be a symbol
    def initialize(name)
      raise(ArgumentError,"Stack name must be a Symbol") if !name.kind_of?(Symbol)
      @name = name
      @entries = []
    end
    
    # Only non-nil objects can be pushed; there is no type checking or validation beyond that.
    def push(item)
      @entries.push(item) unless item == nil
    end
    
    # Removes the last item pushed to the Stack and returns it
    def pop
      return @entries.pop
    end
    
    # Reference to the last item pushed to the Stack. Doesn't remove it
    def peek
      return @entries.last
    end
    
    # Stack#depth returns the number of items
    def depth
      @entries.length
    end
    
  end
  
end