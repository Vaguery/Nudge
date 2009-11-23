module Nudge
  # A Batch is simply an Array of Individuals, with validation for all assignment methods
  class Batch < Array
    
    def self.[](*args)
      raise ArgumentError unless args.inject(true) {|anded, a| anded & a.kind_of?(Individual)}
      super
    end
    
    def []=(index, obj)
      raise ArgumentError unless obj.kind_of?(Individual)
      super
    end
    
    def <<(obj)
      raise ArgumentError unless obj.kind_of?(Individual)
      super
    end
    
    def initialize(*args)
      raise ArgumentError unless args.inject(true) {|anded, a| anded & a.kind_of?(Individual)}
      super
    end
  end
end